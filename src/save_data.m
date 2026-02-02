function save_data(outDir, label, dataTable, eventsTable)
    writetable(dataTable, fullfile(outDir, sprintf('%s_behavior.tsv', label)), 'FileType','text','Delimiter','\t');
    writetable(eventsTable, fullfile(outDir, sprintf('%s_events.tsv', label)), 'FileType','text','Delimiter','\t');
end
