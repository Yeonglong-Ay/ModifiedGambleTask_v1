function response_collection(response)
    % Collect the participant's response
    KbReleaseAll();
    WaitSecs(0.1);
    
    % Return the participant's response
    return response;
end
