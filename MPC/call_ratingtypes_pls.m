function rating_types_pls = call_ratingtypes_pls
%call_ratingtypes
%This function can call dictionary of rating types and prompts.
%its output is rating_types, and it has 3 substructure.
%rating_types.prompts_ex : prompts for explanation
%rating_types.alltypes : dictionary of rating types
%rating_types.prompts : prompts for each rating type


% ********** IMPORTANT NOTE **********
% YOU CAN ADD TYPES AND PROMPTS HERE. "cont_" AND "overall_" ARE IMPORTANT.
% * CRUCIAL: THE ORDER BETWEEN alltypes AND prompts SHOULD BE THE SAME.*


temp_rating_types_pls = {
    'overall_int', '통증이 얼마나 강했나요?';...
    };

rating_types_pls.alltypes = temp_rating_types_pls(:,1);
rating_types_pls.prompts = temp_rating_types_pls(:,2);

rating_types_pls.postallstims = {'REST'};
rating_types_pls.postalltypes{1} = ...
    {'overall_int'};


end
