    
    function z = CheckModifiedConfigFST(full_FAST_FstFile_modified, key, FileModule_modified )
    
    [ ~, cell_ ] = ReadData_v3_2(full_FAST_FstFile_modified,key, '', 0, 0);
    
    File_name_str = cell_.Cell_line_1;
    
    z = strcmp( (File_name_str(2:end-1)), FileModule_modified);
    
    end
