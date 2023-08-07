clear
load("103Vfull.mat")
positions=Data(1).XY;
x=positions(:,1);% x-coordinate of the particle centres
y=positions(:,2);% y-coordinate of the particle centres
xc=(max(x)+min(x))/2;
yc=(max(y)+min(y))/2;
radius = sqrt((max(x)-xc)^2 + (max(y)-xc)^2)-0.6;
% Get the Voronoi vertices and Voronoi regions
[V, C] = voronoin([x, y]);
% Initialize empty arrays to store the coordinates of particles with pentagon and heptagon cells
pentagonParticles = [];
heptagonParticles = [];

% Initialize counters for different polygon types
triangleCount = 0;
quadrilateralCount = 0;
pentagonCount = 0;
hexagonCount = 0;
heptagonCount = 0;
octagonCount = 0;
% Iterate over each Voronoi region
for i = 1:length(C)
    % Get the indices of the Voronoi vertices for the current region
    regionVertices = C{i};
    
    % Check the number of vertices for the current region
    numVertices = length(regionVertices);
    
    % Increment the counter based on the number of vertices
    if numVertices == 3
        triangleCount = triangleCount + 1;
    elseif numVertices == 4
        quadrilateralCount = quadrilateralCount + 1;
    elseif numVertices == 5
        pentagonCount = pentagonCount + 1;
        pentagonParticles = [pentagonParticles; x(i), y(i)];
    elseif numVertices == 6
        hexagonCount = hexagonCount + 1;
    elseif numVertices == 7
        heptagonCount = heptagonCount + 1;
        heptagonParticles = [heptagonParticles; x(i), y(i)];
    elseif numVertices == 8
        octagonCount = octagonCount + 1;
    end
end
pentDist = sqrt((pentagonParticles(:,1)-xc).^2 + (pentagonParticles(:,2)-yc).^2);
heptDist = sqrt((heptagonParticles(:,1)-xc).^2 + (heptagonParticles(:,2)-yc).^2);

% Filter particles arrays to only include those within radius 
pentagonParticles = pentagonParticles(pentDist <= radius, :);
heptagonParticles = heptagonParticles(heptDist <= radius, :);

% Calculate the total number of polygons
totalPolygons = triangleCount + quadrilateralCount + pentagonCount + hexagonCount + heptagonCount + octagonCount;

% Calculate the proportion of each polygon type
triangleProportion = triangleCount / totalPolygons*100;
quadrilateralProportion = quadrilateralCount / totalPolygons*100;
pentagonProportion = pentagonCount / totalPolygons*100;
hexagonProportion = hexagonCount / totalPolygons*100;
heptagonProportion = heptagonCount / totalPolygons*100;
octagonProportion = octagonCount / totalPolygons*100;
% Display the proportions
disp('Proportions of polygon types:');
disp(['Triangles: ', num2str(triangleProportion)]);
disp(['Quadrilaterals: ', num2str(quadrilateralProportion)]);
disp(['Pentagons: ', num2str(pentagonProportion)]);
disp(['Hexagons: ', num2str(hexagonProportion)]);
disp(['Heptagons: ', num2str(heptagonProportion)]);
disp(['Octagons: ', num2str(octagonProportion)]);
figure;
% Plot the particles with pentagon cells as outlined black circles
scatter(pentagonParticles(:, 1), pentagonParticles(:, 2), 'k', 'o', 'LineWidth', 1.5);
hold on;

% Plot the Voronoi diagram
voronoi(x, y);
title('Voronoi Diagram');

% Plot the particles with pentagon cells as outlined black circles
scatter(pentagonParticles(:, 1), pentagonParticles(:, 2), 'k', 'o', 'LineWidth', 1.5);
hold on;

% Plot the particles with heptagon cells as outlined red squares
scatter(heptagonParticles(:, 1), heptagonParticles(:, 2), 'r', 's', 'LineWidth', 1.5);
title('Particles with Pentagon and Heptagon Cells');
xlim([xc-radius xc+radius]) 
ylim([yc-radius yc+radius])
% Set the axis equal
axis equal;