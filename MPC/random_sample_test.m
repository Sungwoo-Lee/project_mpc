clear

addpath(genpath(pwd));

heat_intensity_table = [43, 44, 45, 46, 47, 48];
Trial_nums = 12;

quotient = fix(Trial_nums/length(heat_intensity_table));
remainder = mod(Trial_nums, length(heat_intensity_table));

if not(remainder==0)
    error('Value error! \nmod(trial_num, length(heat_intensity_table)) have to be 0 which is now mod(%d, %d)=%d', ...
    Trial_nums, length(heat_intensity_table), remainder);
end

if not(mod(quotient, 2)==0)
    error('Value error! \nmod(fix(trial_num/length(heat_intensity_table)),2) have to be 0 which is now mod(%d, 2) = %d', ...
        quotient, mod(quotient, 2));
end

heat_program_table = [];
for i = 1:quotient
    heat_program_table = [heat_program_table heat_intensity_table];
end

movie_list = [];
no_movie_list = [];
for i = 1:length(heat_intensity_table)
    movie_list = [movie_list string('movie')];
    no_movie_list = [no_movie_list string('no_movie')];
end

trial_type = [];
for i = 1:fix(quotient/2)
    trial_type = [trial_type movie_list no_movie_list];
end

rng('shuffle')
arr = 1:length(heat_program_table);
sample_index = datasample(arr, length(arr), 'Replace',false);

shuffled_heat = heat_program_table(sample_index);
shuffled_type = trial_type(sample_index);

PathPrg = load_PathProgram('MPC');

for mm = 1:length(heat_program_table)
    index = find([PathPrg{:,1}] == heat_program_table(mm));
    heat_param(mm).program = {PathPrg{index, 2}};
    heat_param(mm).intensity = heat_program_table(mm);
end


