function main_gambletask()
    clc;
    AssertOpenGL;

    addpath(genpath(fileparts(mfilename('fullpath'))));

    subjId = input('Subject ID (e.g., 001): ', 's');
    if isempty(subjId), subjId = '999'; end

    params = load_params(fullfile('config','default_params.json'));
    if params.rngSeed ~= 0
        rng(params.rngSeed);
    else
        rng('shuffle');
    end

    try
        [ptb, io] = init_ptb(params);
        run_experiment(ptb, io, params, subjId);
        sca;
    catch ME
        sca;
        ShowCursor;
        rethrow(ME);
    end
end
