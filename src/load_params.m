function params = load_params(jsonPath)
    txt = fileread(jsonPath);
    params = jsondecode(txt);

    % Convenience: map keys to KbName codes
    params.keys.leftCode  = KbName(params.keys.left);
    params.keys.rightCode = KbName(params.keys.right);
    params.keys.quitCode  = KbName(params.keys.quit);
end
