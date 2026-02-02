function send_trigger(trig, code)
    if isempty(trig) || ~isfield(trig,'enabled') || ~trig.enabled
        return;
    end

    io64(trig.ioObj, trig.address, code);
    WaitSecs(trig.pulseWidthSec);   % 0.005 sec is OK (your spec)
    io64(trig.ioObj, trig.address, 0);
end
