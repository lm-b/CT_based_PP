function [Pressure,Force,Header]=  read_emed_lst(filename, fullSize)
   % [pressure, force, header] = read_emed_lst(filename, [fullSize])
   % read in EMED data from *.lst file contained in 'filename'. 
   %  if 'fullSize' is true (default), return all sensors, including ones
   %    that are not included in the file because they are always zero
   % LST files are arranged in 'pages', where each 'page' is a matrix of
   % pressure data corresponding to a single time point.
   
   Pressure = []; Force = []; Header = ''; % default outputs
   if nargin < 2,
       fullSize = true;  
   end
   
   if exist(filename,'file') ~= 2,
       error('Invalid file "%s"\n', filename);
   end
   fid = fopen(filename,'rt');
   if fid < 1,
      error('Could not open file %s for reading.\n', filename); 
   end
   obj = onCleanup(@() fclose(fid));  % set to close file on return or error
   frewind(fid);
   
   % LST files can get big. Rather than read entire file into memory at once,
   % let's read it in chunks
   chunkSize = 30000;  % bytes, this can be tuned for performance/memory considerations
   pageStart = 'Page ';
   len = length(pageStart)+1;
   nPages = 1000; % assume 1000 pages to start
   pages = cell(nPages,1);  
   tempForce = NaN(nPages,1);
   pageIdx = 0;
   firstPage = true;
   pageText = '';
   running = true;
   EOF = false;
   Sensors = {}; 
   
   while running,
       dataFound = false;
       endPage = strfind(pageText, pageStart);
       pageFound = ~isempty(endPage);
       % if we haven't found a 'Page ', and there are no more chars to 
       % parse from the file, process this last chunk of data as the last
       % iteration of the while loop
       if EOF && ~pageFound,  
          endPage = length(pageText)+1;
          pageFound = true;
          running = false;  % force this to be the last iteration of the loop
       end
       if pageFound,  % pageStart was found
           endPage = endPage(1);  % get only first page found
           [pressure,header, sensors, force] = processPage( pageText(1:(endPage-1)));  
           nextStart = endPage + len;
           pageText = pageText(nextStart:end);
           dataFound = ~isempty(pressure);
       end
       if dataFound,  % pressure data was found
           pageIdx = pageIdx + 1;
           pages{pageIdx} = pressure;
           tempForce(pageIdx)= force;
           Sensors = sensors;
           if firstPage,
              % if first page, save header for output
              % remove leading spaces at each line
              Header=regexprep(header,'\n\s+','\n');
              firstPage = false;
           end
       end
       % we found a page in the existing pageText, so continue to parse it
       if pageFound && ~firstPage,  
           continue;
       else  %otherwise get some more text from the file, and append to pageText
           chars = fread(fid, chunkSize, '*char');
           pageText = [pageText, chars']; %#ok<AGROW>
           EOF = (feof(fid)==1);   % true if we are at end of the file
       end
   end
   nPages = pageIdx;  
   
   % if no pages were parsed, jump out now, returning empty defaults
   if isempty(pages),
       return;
   end
   
   % If fullSize is true, then returned pressure data will contain
   % entire matrix of sensors, including the ones that are always zero and
   % thus are not in the file.
   firstPage = pages{1};
   if fullSize,  % convert to full size
       % get the full size of the matrix from the header text
       matrixSize=regexp(Header,'Matrix:\s+([0-9]+)x([0-9]+)','tokens');
       errstring = 'Matrix size not found in header. Cannot return full size matrix.';
       if length(matrixSize) < 1,
          error(errstring);          
       end
       matrixSize = matrixSize{1};
       if length(matrixSize) < 2,
          error(errstring);
       end
       nRows = str2double(matrixSize{2}); 
       nColumns = str2double(matrixSize{1});
       % also extract the actual sensors that are present in the file
       ix = Sensors{1};
       iy = Sensors{2};
   else  % otherwise, only return the pressure values in the file
      [nRows,nColumns] = size(firstPage); 
      ix = 1:nRows;
      iy = 1:nColumns;
   end
   
   % assemble pressure data as 3D matrix
   Pressure = zeros([nRows,nColumns,nPages],'like',firstPage);
   %Pressure = NaN([nRows,nColumns,nPages],'like',firstPage);
   for k=1:nPages,
       Pressure(ix,iy,k) = pages{k};
   end
   Force = tempForce(1:nPages,:);  % remove the NaN rows from force data
   
end

function [pressure, header, sensors, force] = processPage(page)
    pressure = [];  header = '';  sensors = {}; force = []; % default outputs
    page = strtrim(page);
    if isempty(page),
        return;
    end
    % data is sandwiched between "Force" at end of first line and "Force" at beginning of last line
    % extract the portion of this data as 'dataText'
    str = 'Force';
    forceLoc = strfind(page,str);  % location of 'Force'
    if length(forceLoc) < 2,   % invalid frame-- jump out now
        return;
    end
    loc1 = forceLoc(end-1)-1;
    loc2 = forceLoc(end);
    endlines = ismember(page,char([10 13]));  % locations of line breaks
    firstDataLine = find(endlines(loc1:end),1,'first')+loc1-1;
    lastDataLine = find(endlines(1:loc2),1,'last');
    dataText = strtrim(page(firstDataLine:lastDataLine));
    % first line containing 'Force' is sensor numbers in Y direction, get them
    firstLine = find( endlines(1:loc1),1,'last');  
    header = strtrim(page(1:(firstLine-1)));  % text prior to this location is header for this page
    firstLine = page(firstLine:loc1);
    lastLine = page((loc2+length(str)):end);  % last line
    sensorY =textscan(firstLine,'%d','CollectOutput',true);  % extract sensor numbers (integers)
    sensorY = sensorY{1}';  % make row vector
    numColumns = numel(sensorY)+1;  % +1 to include force column
    data = textscan(dataText,['%d', repmat('%f',[1 numColumns])], 'CollectOutput',true);
    sensorX = data{1};
    data = data{2}; 
    pressure = data(:,1:(end-1));
    forceX = data(:,end);  
    % last line containing 'Force' is force sum over all rows
    forceY = textscan(lastLine,'%f','CollectOutput',true);
    forceY = forceY{1}';
    sensors = {sensorX, sensorY};
    force = forceY(end);  % last element in forceY is total force on platform for that page
end