% Declare filter parameters
nRec = 3;   % Number of recommendations
nhSize = 5; % Neighborhood size

% Load data
data = importdata('recsys-data-sample-rating-matrix.csv');

% Create ratings matrix (100 movies x 25 users)
ratings = data.data;

% Create movie matrix
movies = data.textdata(2:end, 1);
nMovie = length(movies);

% Create users matrix by parsing their IDs from the input data
nUser = size(ratings, 2);
users = nan(nUser, 1);
for iu = 1:nUser
    users(iu) = str2double(data.textdata{1, iu + 1}(2:end-1));
end

% Compute correlation matrix (25 users x 25 users)
r = corr(ratings, 'rows', 'pairwise') - eye(nUser);

% Declare recommendation recipients
recip = [3867 860];
nRecip = length(recip);

% Initialize empty output matrix
outMat = nan(nRecip * nRec, 2, 2);

% For each recipient...
for ir = 1:nRecip
    
    % ...identify their neighborhood
    recipInd = find(users == recip(ir));
    recipCor = r(recipInd, :);
    [nhCor nhInd] = sort(recipCor, 'descend');
    nhInd = nhInd(1:nhSize); % Neighborhood locations
    nhCor = nhCor(1:nhSize); % Neighborhood correlations
    
    % ...initialize an empty matrix of rating predictions
    ratingPred = nan(nMovie, 2);
    
    % ...compute recipient and neighbor mean ratings
    recipMean = nanmean(ratings(:, recipInd));
    nhMean = nanmean(ratings(:, nhInd));
    
    % For each movie...
    for im = 1:nMovie
        
        % ...find neighbor ratings and weights
        nhRatings = ratings(im, nhInd);
        ratingsExist = ~isnan(nhRatings);
        nhRatings = nhRatings(ratingsExist); %neighbor ratings
        nhCorRated = nhCor(ratingsExist); %neighbor correlations
        rWeight = sum(nhCorRated);
        
        % ...compute correlation-weighted average ratings
        weightedRatings = nhRatings * nhCorRated';
        ratingPred(im, 1) = weightedRatings / rWeight;
        
        % ...with normalization
        weightedRatings = (nhRatings - nhMean(ratingsExist)) * nhCorRated';
        ratingPred(im, 2) = recipMean + (weightedRatings / rWeight);
        
    end
    
    % ...remove non-rated movies
    ratingPred = ratingPred(~isnan(ratingPred(:, 1)), :);
    
    % ...sort ratings and select recommendations
    [sortPred sortInd] = sort(ratingPred(:, 1), 'descend');
    recRatings = sortPred(1:nRec);
    recMovies = movies(sortInd(1:nRec));
    
    % ...sort normalized ratings and select recommendations
    [sortPred sortInd] = sort(ratingPred(:, 2), 'descend');
    recRatings_Norm = sortPred(1:nRec);
    recMovies_Norm = movies(sortInd(1:nRec));
    
    % ...fill output matrix
    indFiller = 3 * (ir - 1);
    outMatInd = (1:nRec) + indFiller;
    outMat(outMatInd, 2, 1) = recRatings;
    outMat(outMatInd, 2, 2) = recRatings_Norm;
    for ir2 = 1:nRec
        movieTitle = regexp(recMovies{ir2}, ':', 'split');
        outMat(ir2 + indFiller, 1, 1) = str2double(movieTitle{1});
        movieTitle = regexp(recMovies_Norm{ir2}, ':', 'split');
        outMat(ir2 + indFiller, 1, 2) = str2double(movieTitle{1});
    end
    
end
