package com.erp.sdk.backup;

import com.erp.sdk.config.DatabaseConfig;
import com.erp.sdk.exception.DatabaseOperationException;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public final class MySqlBackupAdapter implements BackupAdapter {
    private static final DateTimeFormatter FORMATTER = DateTimeFormatter.ofPattern("yyyyMMdd_HHmmss");
    private final DatabaseConfig config;

    public MySqlBackupAdapter(DatabaseConfig config) {
        this.config = config;
    }

    @Override
    public Path backupDatabase(String username) {
        try {
            Files.createDirectories(config.backupDirectory());
            Path backupFile = config.backupDirectory()
                    .resolve(config.database() + "_" + username + "_" + FORMATTER.format(LocalDateTime.now()) + ".sql");
            ProcessBuilder processBuilder = new ProcessBuilder(
                    config.dumpCommand(),
                    "--host=" + config.host(),
                    "--port=" + config.port(),
                    "--user=" + config.username(),
                    "--password=" + config.password(),
                    "--routines",
                    "--triggers",
                    "--result-file=" + backupFile.toAbsolutePath(),
                    config.database()
            );
            int exitCode = processBuilder.start().waitFor();
            if (exitCode != 0) {
                throw new DatabaseOperationException("Database backup failed.", null);
            }
            return backupFile;
        } catch (IOException | InterruptedException exception) {
            Thread.currentThread().interrupt();
            throw new DatabaseOperationException("Unable to back up the database.", exception);
        }
    }

    @Override
    public void restoreDatabase(String username, Path backupFile) {
        try {
            ProcessBuilder processBuilder = new ProcessBuilder(
                    config.restoreCommand(),
                    "--host=" + config.host(),
                    "--port=" + String.valueOf(config.port()),
                    "--user=" + config.username(),
                    "--password=" + config.password(),
                    config.database(),
                    "-e",
                    "source " + backupFile.toAbsolutePath()
            );
            int exitCode = processBuilder.start().waitFor();
            if (exitCode != 0) {
                throw new DatabaseOperationException("Database restore failed.", null);
            }
        } catch (IOException | InterruptedException exception) {
            Thread.currentThread().interrupt();
            throw new DatabaseOperationException("Unable to restore the database.", exception);
        }
    }
}
