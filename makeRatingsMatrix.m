% Load data of user IDs, movie IDs, and ratings
data = csvread('recsys-data-ratings.csv');

% Parse the data into users, movies, and ratings variables
u = data(:, 1); % Users
m = data(:, 2); % Movies
r = data(:, 3); % Ratings
clear data

% Identify unique users and movies
unqUser = unique(u);
unqMovie = unique(m);

% Count them
nUser = size(unqUser, 1);
nMovie = size(unqMovie, 1);

% Initialize an empty ratings matrix
ratingsMatrix = nan(nUser, nMovie);

% For every user...
for iu = 1:nUser
    thisUser = unqUser(iu);
    
    % ...and for every movie...
    for im = 1:nMovie
        thisMovie = unqMovie(im);
        
        % ...find the intersection of their indices
        intxnUserMovie = (u == thisUser) & (m == thisMovie);
        
        % ...if the user rated this movie, then fill the ratings matrix
        if any(intxnUserMovie)
           ratingsMatrix(iu, im) = r(intxnUserMovie); 
        end
        
    end
    
end

% Save complete ratings matrix
save('ratingsMatrix', ratingsMatrix);
