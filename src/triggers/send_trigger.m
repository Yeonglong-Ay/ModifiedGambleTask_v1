function send_trigger(trig, code)
    if isempty(trig) || ~isfield(trig,'enabled') || ~trig.enabled
        return;
    end
    if ~isnumeric(code)
        error('Trigger code must be numeric.');
    end

    switch trig.mode
        case "parallel"
            io64(trig.ioObj, trig.address, code);
            WaitSecs(trig.pulseWidthSec);
            io64(trig.ioObj, trig.address, 0);

        case "serial"
            IOPort('Write', trig.serialHandle, uint8(code));

        otherwise
            % no-op
    end
end
