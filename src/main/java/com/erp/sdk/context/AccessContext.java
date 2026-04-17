package com.erp.sdk.context;

import com.erp.sdk.subsystem.SubsystemName;

public record AccessContext(SubsystemName subsystem, String username) {
}
