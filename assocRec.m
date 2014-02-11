% Declare filter parameter
nRec = 5; % Number of recommendations

% Load ratings matrix (users x movies)
[ratingsMatrix, movieID] = makeRatingsMatrix('recsys-data-ratings.csv');

% Binarize ratings matrix (user i rated movie j if ratingsMatrix(i, j) = 1)
ratingsMatrix = ~isnan(ratingsMatrix);

% Find similar movies to these
target = [3049 107 1891];

% Movie declarations
nTarget = length(target);
nTotalMovie = length(movieID);

% Initialize empty results struct
top.both.prop = {};
top.both.movies = {};
top.others.prop = {};
top.others.movies = {};

% For every target movie...
for m = 1:nTarget
    
    % ...find which users rated it
    movieInd = find(target(m) == movieID);
    rated = ratingsMatrix(:, movieInd);
    ratedMatrix = repmat(rated, 1, nTotalMovie);
    
    % ...and how often they rated every other movie
    propBoth = sum(ratingsMatrix & ratedMatrix) / sum(rated);
    propBoth(movieInd) = [];
    [sortPropBoth sortInd] = sort(propBoth, 'descend');
    top.both.prop{m} = sortPropBoth(1:nRec);
    top.both.movies{m} = movieID(sortInd(1:nRec))';
    
    % ...normalize by proportion of users who did not watch target movie
    propOthers = sum(ratingsMatrix & ~ratedMatrix) / sum(~rated);
    propOthers(movieInd) = [];
    [sortPropOthers sortInd] = sort(propBoth ./ propOthers, 'descend');
    top.others.prop{m} = sortPropOthers(1:nRec);
    top.others.movies{m} = movieID(sortInd(1:nRec))';
    
end
