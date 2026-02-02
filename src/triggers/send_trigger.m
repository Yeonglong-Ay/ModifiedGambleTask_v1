function send_trigger(trig, code)
% Sends a TTL pulse with given integer code.
% For parallel: writes code, waits pulseWidthSec, resets to 0.
% For serial: writes a single byte (uint8). Adjust to your acquisition system.

    if isempty(trig) || ~isfield(trig,'enabled') || ~trig.enabled
        return;
    end

    if isnumeric(code) == false
        error('Trigger code must be numeric.');
    end

    switch trig.mode
        case "parallel"
            io64(trig.ioObj, trig.address, code);
            WaitSecs(trig.pulseWidthSec);
            io64(trig.ioObj, trig.address, 0);

        case "serial"
            IOPort('Write', trig.serialHandle, uint8(code));
            % optionally add a reset byte if your system expects it

        otherwise
            % no-op
    end
end
