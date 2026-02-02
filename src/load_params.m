function params = load_params(jsonPath)
    txt = fileread(jsonPath);
    params = jsondecode(txt);

    params.keys.leftCode  = KbName(params.keys.left);
    params.keys.rightCode = KbName(params.keys.right);
    params.keys.quitCode  = KbName(params.keys.quit);

    proceedList = params.keys.proceedPractice;
    if ischar(proceedList) || isstring(proceedList)
        proceedList = {char(proceedList)};
    end
    params.keys.proceedCodes = cellfun(@(k) KbName(k), proceedList);
end
