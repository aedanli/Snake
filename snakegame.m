clear all;

% Aedan Yue Li
% Memory & Perception Lab, University of Toronto
% August 27, 2017

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% SNAKE GAME %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% CONTROLS:

% A - LEFT
% D - RIGHT
% W - UP
% S - DOWN

% ESC - PAUSE
% 0 - RESTART

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% OPTIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

world_size = [30]; % set world size
game_speed = [0.05]; % set snake travel speed in seconds
item_size = [400]; % size of items
snake_size = 1; % set default snake size
winning_points = [30]; % set points to win game
borders_on = [1]; % if one, turn borders on; if 0, turn off
self_harm_on = [1]; % if one, turn self harm on

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

rng('shuffle'); % reinitialize rng

snake_game = figure('KeyPressFcn', {@keypress_Callback});

% State builder
matrix_world_state = zeros(world_size); % world matrix
game_state = 1; % while true

% rand food position
food_pos_x = randi((world_size),1);
food_pos_y = randi((world_size),1);
% resize snake relative to world size
item_size = item_size/world_size; 

% generate the snake position on game state
current_pos_x = randi(world_size,1);
current_pos_y = randi(world_size,1);

while game_state == 1
% build snake
snake_matrix = [current_pos_x, current_pos_y];

for ii = 1:snake_size
    snake_matrix(ii,:) = [current_pos_x - ii, current_pos_y];
end
moving_snake = snake_matrix;
    
% while true
snake_game = 1;
game_speed_mode = game_speed;

while snake_game == 1
    % food
    if moving_snake(1,1) == food_pos_x && moving_snake(1,2) == food_pos_y
       food_pos_x = randi(world_size,1);
       food_pos_y = randi(world_size,1);
       snake_size = snake_size + 1;
    end    
    
   % if left key
   if get(snake_game, 'CurrentKey') == 'a'
        moving_snake(2:snake_size,1) = moving_snake(1:snake_size-1,1);
        moving_snake(2:snake_size,2) = moving_snake(1:snake_size-1,2);
        moving_snake(1,1) = moving_snake(1,1) - 1;
        moving_snake(1,2) = moving_snake(1,2);
        if borders_on == 0
            if moving_snake(1,1) < 0
                moving_snake(1,1) = moving_snake(1,1) + world_size;
            end
        end
        
   % if right key
   elseif get(snake_game, 'CurrentKey') == 'd'     
        moving_snake(2:snake_size,1) = moving_snake(1:snake_size-1,1);
        moving_snake(2:snake_size,2) = moving_snake(1:snake_size-1,2);
        moving_snake(1,1) = moving_snake(1,1) + 1;
        moving_snake(1,2) = moving_snake(1,2);   
        if borders_on == 0
            if moving_snake(1,1) > world_size
                moving_snake(1,1) = moving_snake(1,1) - world_size;
            end
        end
   
   % if up key
   elseif get(snake_game, 'CurrentKey') == 'w' 
        moving_snake(2:snake_size,1) = moving_snake(1:snake_size-1,1);
        moving_snake(2:snake_size,2) = moving_snake(1:snake_size-1,2);
        moving_snake(1,1) = moving_snake(1,1);
        moving_snake(1,2) = moving_snake(1,2) + 1;   
        if borders_on == 0
            if moving_snake(1,2) > world_size
                moving_snake(1,2) = moving_snake(1,2) - world_size;
            end
        end
  
   % if down key     
   elseif get(snake_game, 'CurrentKey') == 's'
        moving_snake(2:snake_size,1) = moving_snake(1:snake_size-1,1);
        moving_snake(2:snake_size,2) = moving_snake(1:snake_size-1,2);
        moving_snake(1,1) = moving_snake(1,1);
        moving_snake(1,2) = moving_snake(1,2) - 1;  
        if borders_on == 0
            if moving_snake(1,2) < 0
                moving_snake(1,2) = moving_snake(1,2) + world_size;
            end
        end
   end
   
   if borders_on == 1
   % if you hit border, end game
   if abs(moving_snake(1,1)) == world_size+1 || moving_snake(1,1) < 0
       snake_size = 0;
       disp('GG Noob')
   elseif abs(moving_snake(1,2)) == world_size+1 || moving_snake(1,2) < 0  
       snake_size = 0;
       disp('GG Noob')
   else
   end
   end
   
   % if you press 0, restart game
   if get(snake_game, 'CurrentKey') == '0'
        snake_size = 1;
        snake_game = 0;
   else
        current_pos_x = randi(world_size,1);
        current_pos_y = randi(world_size,1);
   end
   
   if self_harm_on == 1
   % if you hit yourself, end game
   if snake_size > 1
       if sum(ismember(moving_snake(2:snake_size,:), moving_snake(1,:),'rows')) == 1
       snake_size = 0;
       disp('GG Noob')
       end
   end
   end       
   
   % if points greater than winning points set
   if snake_size > winning_points
       disp('You win!')
       waitforbuttonpress;
   end
   
% plot snake
for ii = 1:snake_size
    plot([moving_snake(ii,1) moving_snake(ii,1)], [moving_snake(ii,2) moving_snake(ii,2)], 's', 'MarkerFaceColor', [.95 .95 .95], 'MarkerSize', item_size);
    hold on
end
    plot(food_pos_x, food_pos_y, '.', 'MarkerSize', item_size);
    axis([0, world_size, 0, world_size])%creates the axis for gameplay
    title(['Score = ' num2str(snake_size-1)])
    set(gca,'xtick',[])
    set(gca,'xticklabel',[])
    set(gca,'ytick',[])
    set(gca,'yticklabel',[])
    hold off
    
pause(game_speed_mode) % delay

end
end


% shows key pressed and returns to game
function keypress_Callback(keypress, ~)
get(keypress, 'CurrentKey');
end