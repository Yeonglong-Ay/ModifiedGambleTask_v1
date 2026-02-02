function trig = init_triggers(params)
% Initialize TTL trigger output.
% Supports:
%  - parallel port using io64
%  - serial using Psychtoolbox IOPort
%
% Returns struct trig used by send_trigger().

    trig = struct();
    trig.enabled = isfield(params, 'triggers') && params.triggers.enabled;

    if ~trig.enabled
        trig.mode = "none";
        return;
    end

    trig.mode = string(params.triggers.mode);
    trig.pulseWidthSec = params.triggers.pulseWidthSec;
    trig.codes = params.triggers.codes;

    switch trig.mode
        case "parallel"
            trig.ioObj = io64;
            status = io64(trig.ioObj);
            if status ~= 0
                error('io64 initialization failed (status=%d). Check io64 installation/driver.', status);
            end

            addrHex = params.triggers.parallel.addressHex;
            trig.address = hex2dec(addrHex);

            % reset line
            io64(trig.ioObj, trig.address, 0);

        case "serial"
            port = params.triggers.serial.port;
            baud = params.triggers.serial.baud;

            trig.serialHandle = IOPort('OpenSerialPort', port, sprintf('BaudRate=%d', baud));
            IOPort('Flush', trig.serialHandle);

        otherwise
            error('Unknown trigger mode: %s', trig.mode);
    end
end
