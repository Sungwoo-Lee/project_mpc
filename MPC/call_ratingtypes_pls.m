function rating_types_pls = call_ratingtypes_pls(type)
%call_ratingtypes
%This function can call dictionary of rating types and prompts.
%its output is rating_types, and it has 3 substructure.
%rating_types.prompts_ex : prompts for explanation
%rating_types.alltypes : dictionary of rating types
%rating_types.prompts : prompts for each rating type


% ********** IMPORTANT NOTE **********
% YOU CAN ADD TYPES AND PROMPTS HERE. "cont_" AND "overall_" ARE IMPORTANT.
% * CRUCIAL: THE ORDER BETWEEN alltypes AND prompts SHOULD BE THE SAME.*

switch type
    case 'temp'
        temp_rating_types_pls = {
            'overall_int', '통증이 얼마나 강했나요?';...
            };
        
        rating_types_pls.alltypes = temp_rating_types_pls(:,1);
        rating_types_pls.prompts = temp_rating_types_pls(:,2);
        
        rating_types_pls.postallstims = {'REST'};
        rating_types_pls.postalltypes{1} = ...
            {'overall_int'};
    case 'continue'
        temp_rating_types_pls = {
            'overall_int', '통증이 얼마나 강한가요?';...
            };
        
        rating_types_pls.alltypes = temp_rating_types_pls(:,1);
        rating_types_pls.prompts = temp_rating_types_pls(:,2);
        
        rating_types_pls.postallstims = {'REST'};
        rating_types_pls.postalltypes{1} = ...
            {'overall_int'};
    case 'deliver'
        temp_rating_types_pls = {
            'overall_int', '통증이 얼마나 강한가요?';...
            };
        
        rating_types_pls.alltypes = temp_rating_types_pls(:,1);
        rating_types_pls.prompts = temp_rating_types_pls(:,2);
        
        rating_types_pls.postallstims = {'REST'};
        rating_types_pls.postalltypes{1} = ...
            {'overall_int'};
    case 'remove'
        temp_rating_types_pls = {
            'overall_int', '통증이 얼마나 강한가요?';...
            };
        
        rating_types_pls.alltypes = temp_rating_types_pls(:,1);
        rating_types_pls.prompts = temp_rating_types_pls(:,2);
        
        rating_types_pls.postallstims = {'REST'};
        rating_types_pls.postalltypes{1} = ...
            {'overall_int'};
        
        
    case 'resting'
        temp_rating_types_pls = {
            'resting_int', '\n+';...
            };
        
        rating_types_pls.alltypes = temp_rating_types_pls(:,1);
        rating_types_pls.prompts = temp_rating_types_pls(:,2);
        
        rating_types_pls.postallstims = {'REST'};
        rating_types_pls.postalltypes{1} = ...
            {'resting_int'};
        
        
    case 'post_movie_rating'
        temp_rating_types_pls = {
            'resting_int', '\n+';...
            };
        
        rating_types_pls.alltypes = temp_rating_types_pls(:,1);
        rating_types_pls.prompts = temp_rating_types_pls(:,2);
        
        rating_types_pls.postallstims = {'REST'};
        rating_types_pls.postalltypes{1} = ...
            {'overall_glms'};
        
                
        
    case 'overall_alertness'
        temp_rating_types_pls = {
            'overall_alertness', '방금 세션동안 얼마나 졸리셨나요, 혹은 얼마나 정신이 또렷했나요?';...
            };
        
        rating_types_pls.alltypes = temp_rating_types_pls(:,1);
        rating_types_pls.prompts = temp_rating_types_pls(:,2);
        
        rating_types_pls.postallstims = {'REST'};
        rating_types_pls.postalltypes{1} = ...
            {'overall_alertness'};        
        
    case 'overall_relaxed'
        temp_rating_types_pls = {
            'resting_int', '지금 얼마나 편안한 상태이신가요?';...
            };
        
        rating_types_pls.alltypes = temp_rating_types_pls(:,1);
        rating_types_pls.prompts = temp_rating_types_pls(:,2);
        
        rating_types_pls.postallstims = {'REST'};
        rating_types_pls.postalltypes{1} = ...
            {'overall_relaxed'};        
        
    case 'overall_attention'
        temp_rating_types_pls = {
            'resting_int', '방금 세션동안 과제에 얼마나 집중하셨나요?';...
            };
        
        rating_types_pls.alltypes = temp_rating_types_pls(:,1);
        rating_types_pls.prompts = temp_rating_types_pls(:,2);
        
        rating_types_pls.postallstims = {'REST'};
        rating_types_pls.postalltypes{1} = ...
            {'overall_attention'};        
        
    case 'overall_resting_positive'
        temp_rating_types_pls = {
            'resting_int', '방금 세션동안 했던 생각이 주로 긍정적이었나요?';...
            };
        
        rating_types_pls.alltypes = temp_rating_types_pls(:,1);
        rating_types_pls.prompts = temp_rating_types_pls(:,2);
        
        rating_types_pls.postallstims = {'REST'};
        rating_types_pls.postalltypes{1} = ...
            {'overall_resting_positive'};        
        
    case 'overall_resting_negative'
        temp_rating_types_pls = {
            'resting_int', '방금 세션동안 했던 생각이 주로 부정적이었나요?';...
            };
        
        rating_types_pls.alltypes = temp_rating_types_pls(:,1);
        rating_types_pls.prompts = temp_rating_types_pls(:,2);
        
        rating_types_pls.postallstims = {'REST'};
        rating_types_pls.postalltypes{1} = ...
            {'overall_resting_negative'};        
        
    case 'overall_resting_myself'
        temp_rating_types_pls = {
            'resting_int', '방금 세션동안 했던 생각이 주로 나 자신에 대한 것이었나요?';...
            };
        
        rating_types_pls.alltypes = temp_rating_types_pls(:,1);
        rating_types_pls.prompts = temp_rating_types_pls(:,2);
        
        rating_types_pls.postallstims = {'REST'};
        rating_types_pls.postalltypes{1} = ...
            {'overall_resting_myself'};        
        
    case 'overall_resting_others'
        temp_rating_types_pls = {
            'resting_int', '방금 세션동안 했던 생각이 주로 다른 사람들에 대한 것이었나요?';...
            };
        
        rating_types_pls.alltypes = temp_rating_types_pls(:,1);
        rating_types_pls.prompts = temp_rating_types_pls(:,2);
        
        rating_types_pls.postallstims = {'REST'};
        rating_types_pls.postalltypes{1} = ...
            {'overall_resting_others'};        
        
    case 'overall_resting_imagery'
        temp_rating_types_pls = {
            'resting_int', '방금 세션동안 했던 생각이 주로 생생한 이미지를 포함하고 있었나요?';...
            };
        
        rating_types_pls.alltypes = temp_rating_types_pls(:,1);
        rating_types_pls.prompts = temp_rating_types_pls(:,2);
        
        rating_types_pls.postallstims = {'REST'};
        rating_types_pls.postalltypes{1} = ...
            {'overall_resting_imagery'};        
        
    case 'overall_resting_present'
        temp_rating_types_pls = {
            'resting_int', '방금 세션동안 했던 생각이 주로 지금, 여기에 대한 것이었나요?';...
            };
        
        rating_types_pls.alltypes = temp_rating_types_pls(:,1);
        rating_types_pls.prompts = temp_rating_types_pls(:,2);
        
        rating_types_pls.postallstims = {'REST'};
        rating_types_pls.postalltypes{1} = ...
            {'overall_resting_present'};        
        
    case 'overall_resting_past'
        temp_rating_types_pls = {
            'resting_int', '방금 세션동안 주로 했던 생각이 과거에 대한 것이었나요?';...
            };
        
        rating_types_pls.alltypes = temp_rating_types_pls(:,1);
        rating_types_pls.prompts = temp_rating_types_pls(:,2);
        
        rating_types_pls.postallstims = {'REST'};
        rating_types_pls.postalltypes{1} = ...
            {'overall_resting_past'};
        
        
    case 'overall_resting_future'
        temp_rating_types_pls = {
            'resting_int', '방금 세션동안 주로 했던 생각이 미래에 대한 것이었나요?';...
            };
        
        rating_types_pls.alltypes = temp_rating_types_pls(:,1);
        rating_types_pls.prompts = temp_rating_types_pls(:,2);
        
        rating_types_pls.postallstims = {'REST'};
        rating_types_pls.postalltypes{1} = ...
            {'overall_resting_future'};
        
                
    case 'overall_resting_capsai_int'
        temp_rating_types_pls = {
            'resting_int', '방금 세션동안 경험했던 혀의 통증은 가장 심했을 때 얼마나 강했나요?';...
            };
        
        rating_types_pls.alltypes = temp_rating_types_pls(:,1);
        rating_types_pls.prompts = temp_rating_types_pls(:,2);
        
        rating_types_pls.postallstims = {'REST'};
        rating_types_pls.postalltypes{1} = ...
            {'overall_resting_capsai_int'};
        
                
    case 'overall_resting_capsai_glms'
        temp_rating_types_pls = {
            'resting_int', '방금 세션동안 경험했던 혀의 통증은 가장 심했을 때 얼마나 불쾌했나요?';...
            };
        
        rating_types_pls.alltypes = temp_rating_types_pls(:,1);
        rating_types_pls.prompts = temp_rating_types_pls(:,2);
        
        rating_types_pls.postallstims = {'REST'};
        rating_types_pls.postalltypes{1} = ...
            {'overall_resting_capsai_glms'};
        
    case 'overall_resting_valence'
        temp_rating_types_pls = {
            'resting_int', '방금 세션동안 했던 생각이 긍정적 혹은 부정적이었나요?';...
            };
        
        rating_types_pls.alltypes = temp_rating_types_pls(:,1);
        rating_types_pls.prompts = temp_rating_types_pls(:,2);
        
        rating_types_pls.postallstims = {'REST'};
        rating_types_pls.postalltypes{1} = ...
            {'overall_resting_capsai_glms'};
        
    case 'overall_resting_self'
        temp_rating_types_pls = {
            'resting_int', '방금 세션동안 했던 생각이 얼마나 나 자신과 관련된 것이었나요?';...
            };
        
        rating_types_pls.alltypes = temp_rating_types_pls(:,1);
        rating_types_pls.prompts = temp_rating_types_pls(:,2);
        
        rating_types_pls.postallstims = {'REST'};
        rating_types_pls.postalltypes{1} = ...
            {'overall_resting_capsai_glms'};

    case 'overall_resting_vivid'
        temp_rating_types_pls = {
            'resting_int', '방금 세션동안 했던 생각이 주로 생생한 이미지를 포함하고 있었나요?';...
            };
        
        rating_types_pls.alltypes = temp_rating_types_pls(:,1);
        rating_types_pls.prompts = temp_rating_types_pls(:,2);
        
        rating_types_pls.postallstims = {'REST'};
        rating_types_pls.postalltypes{1} = ...
            {'overall_resting_capsai_glms'};
        
    case 'overall_resting_time'
        temp_rating_types_pls = {
            'resting_int', '방금 세션동안 주로 했던 생각이 과거 혹은 미래에 대한 것이었나요?';...
            };
        
        rating_types_pls.alltypes = temp_rating_types_pls(:,1);
        rating_types_pls.prompts = temp_rating_types_pls(:,2);
        
        rating_types_pls.postallstims = {'REST'};
        rating_types_pls.postalltypes{1} = ...
            {'overall_resting_capsai_glms'};
        
     case 'overall_resting_safethreat'
        temp_rating_types_pls = {
            'resting_int', '방금 세션동안 주로 했던 생각이 위협적인 혹은 안전한 생각이었나요?';...
            };
        
        rating_types_pls.alltypes = temp_rating_types_pls(:,1);
        rating_types_pls.prompts = temp_rating_types_pls(:,2);
        
        rating_types_pls.postallstims = {'REST'};
        rating_types_pls.postalltypes{1} = ...
            {'overall_resting_capsai_glms'};
               
        
end
