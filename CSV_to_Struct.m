% Read the CSV file
data = readmatrix('Give your csv here');

% Extract X, Y coordinates, and frame numbers, use the column numbers specific to your csv
X = data(:, 4);
Y = data(:, 5);
frameNumbers = data(:, 9);

% Get unique frame numbers
Frames = unique(frameNumbers);

% Create the structure
Data = struct('XY', []);

% Iterate over unique frame numbers
for i = 1:length(Frames)
    frame = Frames(i);
    
    % Find indices corresponding to the current frame
    indices = find(frameNumbers == frame);
    
    % Extract X and Y coordinates for the current frame
    xData = X(indices);
    yData = Y(indices);
    
    % Store the coordinates in the structure
    Data(i).XY = [xData, yData];
end
emptyRows = cellfun(@isempty, {Data.XY});
Data(emptyRows) = [];
% Access the data for a specific frame (e.g., frame 1)
frame1Data = Data(1).XY;
clear data frame1Data frameNumbers yData xData indices Y X frame Frames i emptyRows
