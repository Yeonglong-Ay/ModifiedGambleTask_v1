function trig = init_triggers(params)
    trig = struct();
    trig.enabled = isfield(params,'triggers') && params.triggers.enabled;

    if ~trig.enabled
        trig.mode = "none";
        return;
    end

    trig.mode = string(params.triggers.mode);
    trig.pulseWidthSec = params.triggers.pulseWidthSec;
    trig.codes = params.triggers.codes;

    if trig.mode ~= "parallel"
        error('This build is configured for parallel TTL (io64).');
    end

    trig.ioObj = io64;
    status = io64(trig.ioObj);
    if status ~= 0
        error('io64 initialization failed (status=%d). Check driver/install.', status);
    end

    trig.address = hex2dec(params.triggers.parallel.addressHex);

    % Reset
    io64(trig.ioObj, trig.address, 0);
end
