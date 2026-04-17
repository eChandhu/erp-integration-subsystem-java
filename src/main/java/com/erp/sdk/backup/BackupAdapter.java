package com.erp.sdk.backup;

import java.nio.file.Path;

public interface BackupAdapter {
    Path backupDatabase(String username);

    void restoreDatabase(String username, Path backupFile);
}
