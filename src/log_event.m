function ev = log_event(name, timestamp, trial)
    ev = struct();
    ev.event = string(name);
    ev.timeSec = timestamp;

    ev.trialIndex = getfield_safe(trial,'trialIndex',NaN);
    ev.session = getfield_safe(trial,'session',NaN);
    ev.blockIndex = getfield_safe(trial,'blockIndex',NaN);
    ev.blockType = string(getfield_safe(trial,'blockType',""));
end

function v = getfield_safe(s, fname, defaultVal)
    if isfield(s, fname)
        v = s.(fname);
    else
        v = defaultVal;
    end
end
