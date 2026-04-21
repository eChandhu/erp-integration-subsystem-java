package com.likeseca.erp.database.facade;

import com.likeseca.erp.database.adapter.AccountingAdapter;
import com.likeseca.erp.database.adapter.AutomationAdapter;
import com.likeseca.erp.database.adapter.BusinessControlAdapter;
import com.likeseca.erp.database.adapter.BusinessIntelligenceAdapter;
import com.likeseca.erp.database.adapter.CrmAdapter;
import com.likeseca.erp.database.adapter.DataAnalyticsAdapter;
import com.likeseca.erp.database.adapter.DatabaseIntegrationAdapter;
import com.likeseca.erp.database.adapter.FinancialManagementAdapter;
import com.likeseca.erp.database.adapter.HrAdapter;
import com.likeseca.erp.database.adapter.ManufacturingAdapter;
import com.likeseca.erp.database.adapter.MarketingAdapter;
import com.likeseca.erp.database.adapter.OrderProcessingAdapter;
import com.likeseca.erp.database.adapter.ProjectManagementAdapter;
import com.likeseca.erp.database.adapter.ReportingAdapter;
import com.likeseca.erp.database.adapter.SalesManagementAdapter;
import com.likeseca.erp.database.adapter.SupplyChainAdapter;
import com.likeseca.erp.database.adapter.UiAdapter;
import com.likeseca.erp.database.config.DatabaseConnectionManager;
import com.likeseca.erp.database.config.SchemaBootstrapper;
import com.likeseca.erp.database.facade.subsystem.AccountingSubsystemFacade;
import com.likeseca.erp.database.facade.subsystem.AutomationSubsystemFacade;
import com.likeseca.erp.database.facade.subsystem.BusinessControlSubsystemFacade;
import com.likeseca.erp.database.facade.subsystem.BusinessIntelligenceSubsystemFacade;
import com.likeseca.erp.database.facade.subsystem.CrmSubsystemFacade;
import com.likeseca.erp.database.facade.subsystem.DataAnalyticsSubsystemFacade;
import com.likeseca.erp.database.facade.subsystem.DatabaseIntegrationSubsystemFacade;
import com.likeseca.erp.database.facade.subsystem.FinancialManagementSubsystemFacade;
import com.likeseca.erp.database.facade.subsystem.HrSubsystemFacade;
import com.likeseca.erp.database.facade.subsystem.ManufacturingSubsystemFacade;
import com.likeseca.erp.database.facade.subsystem.MarketingSubsystemFacade;
import com.likeseca.erp.database.facade.subsystem.OrderProcessingSubsystemFacade;
import com.likeseca.erp.database.facade.subsystem.ProjectManagementSubsystemFacade;
import com.likeseca.erp.database.facade.subsystem.ReportingSubsystemFacade;
import com.likeseca.erp.database.facade.subsystem.SalesManagementSubsystemFacade;
import com.likeseca.erp.database.facade.subsystem.SupplyChainSubsystemFacade;
import com.likeseca.erp.database.facade.subsystem.UiSubsystemFacade;
import com.likeseca.erp.database.security.PermissionService;
import com.likeseca.erp.database.service.JdbcOperations;
import com.likeseca.erp.database.service.PermissionAwareOperations;

public final class ErpDatabaseFacade implements AutoCloseable {
    private final DatabaseIntegrationAdapter databaseIntegration;
    private final UiAdapter ui;
    private final CrmAdapter crm;
    private final MarketingAdapter marketing;
    private final SalesManagementAdapter salesManagement;
    private final OrderProcessingAdapter orderProcessing;
    private final SupplyChainAdapter supplyChain;
    private final ManufacturingAdapter manufacturing;
    private final HrAdapter hr;
    private final ProjectManagementAdapter projectManagement;
    private final ReportingAdapter reporting;
    private final DataAnalyticsAdapter dataAnalytics;
    private final BusinessIntelligenceAdapter businessIntelligence;
    private final AutomationAdapter automation;
    private final BusinessControlAdapter businessControl;
    private final FinancialManagementAdapter financialManagement;
    private final AccountingAdapter accounting;
    private final DatabaseIntegrationSubsystemFacade databaseIntegrationSubsystemFacade;
    private final UiSubsystemFacade uiSubsystemFacade;
    private final CrmSubsystemFacade crmSubsystemFacade;
    private final MarketingSubsystemFacade marketingSubsystemFacade;
    private final SalesManagementSubsystemFacade salesManagementSubsystemFacade;
    private final OrderProcessingSubsystemFacade orderProcessingSubsystemFacade;
    private final SupplyChainSubsystemFacade supplyChainSubsystemFacade;
    private final ManufacturingSubsystemFacade manufacturingSubsystemFacade;
    private final HrSubsystemFacade hrSubsystemFacade;
    private final ProjectManagementSubsystemFacade projectManagementSubsystemFacade;
    private final ReportingSubsystemFacade reportingSubsystemFacade;
    private final DataAnalyticsSubsystemFacade dataAnalyticsSubsystemFacade;
    private final BusinessIntelligenceSubsystemFacade businessIntelligenceSubsystemFacade;
    private final AutomationSubsystemFacade automationSubsystemFacade;
    private final BusinessControlSubsystemFacade businessControlSubsystemFacade;
    private final FinancialManagementSubsystemFacade financialManagementSubsystemFacade;
    private final AccountingSubsystemFacade accountingSubsystemFacade;

    public ErpDatabaseFacade() {
        SchemaBootstrapper.ensureSchemaInitialized();
        PermissionAwareOperations operations = new PermissionAwareOperations(new PermissionService(), new JdbcOperations());
        this.databaseIntegration = new DatabaseIntegrationAdapter(operations);
        this.ui = new UiAdapter(operations);
        this.crm = new CrmAdapter(operations);
        this.marketing = new MarketingAdapter(operations);
        this.salesManagement = new SalesManagementAdapter(operations);
        this.orderProcessing = new OrderProcessingAdapter(operations);
        this.supplyChain = new SupplyChainAdapter(operations);
        this.manufacturing = new ManufacturingAdapter(operations);
        this.hr = new HrAdapter(operations);
        this.projectManagement = new ProjectManagementAdapter(operations);
        this.reporting = new ReportingAdapter(operations);
        this.dataAnalytics = new DataAnalyticsAdapter(operations);
        this.businessIntelligence = new BusinessIntelligenceAdapter(operations);
        this.automation = new AutomationAdapter(operations);
        this.businessControl = new BusinessControlAdapter(operations);
        this.financialManagement = new FinancialManagementAdapter(operations);
        this.accounting = new AccountingAdapter(operations);
        this.databaseIntegrationSubsystemFacade = new DatabaseIntegrationSubsystemFacade(databaseIntegration);
        this.uiSubsystemFacade = new UiSubsystemFacade(ui);
        this.crmSubsystemFacade = new CrmSubsystemFacade(crm);
        this.marketingSubsystemFacade = new MarketingSubsystemFacade(marketing);
        this.salesManagementSubsystemFacade = new SalesManagementSubsystemFacade(salesManagement);
        this.orderProcessingSubsystemFacade = new OrderProcessingSubsystemFacade(orderProcessing);
        this.supplyChainSubsystemFacade = new SupplyChainSubsystemFacade(supplyChain);
        this.manufacturingSubsystemFacade = new ManufacturingSubsystemFacade(manufacturing);
        this.hrSubsystemFacade = new HrSubsystemFacade(hr);
        this.projectManagementSubsystemFacade = new ProjectManagementSubsystemFacade(projectManagement);
        this.reportingSubsystemFacade = new ReportingSubsystemFacade(reporting);
        this.dataAnalyticsSubsystemFacade = new DataAnalyticsSubsystemFacade(dataAnalytics);
        this.businessIntelligenceSubsystemFacade = new BusinessIntelligenceSubsystemFacade(businessIntelligence);
        this.automationSubsystemFacade = new AutomationSubsystemFacade(automation);
        this.businessControlSubsystemFacade = new BusinessControlSubsystemFacade(businessControl);
        this.financialManagementSubsystemFacade = new FinancialManagementSubsystemFacade(financialManagement);
        this.accountingSubsystemFacade = new AccountingSubsystemFacade(accounting);
    }

    public DatabaseIntegrationAdapter databaseIntegration() { return databaseIntegration; }
    public UiAdapter ui() { return ui; }
    public CrmAdapter crm() { return crm; }
    public MarketingAdapter marketing() { return marketing; }
    public SalesManagementAdapter salesManagement() { return salesManagement; }
    public OrderProcessingAdapter orderProcessing() { return orderProcessing; }
    public SupplyChainAdapter supplyChain() { return supplyChain; }
    public ManufacturingAdapter manufacturing() { return manufacturing; }
    public HrAdapter hr() { return hr; }
    public ProjectManagementAdapter projectManagement() { return projectManagement; }
    public ReportingAdapter reporting() { return reporting; }
    public DataAnalyticsAdapter dataAnalytics() { return dataAnalytics; }
    public BusinessIntelligenceAdapter businessIntelligence() { return businessIntelligence; }
    public AutomationAdapter automation() { return automation; }
    public BusinessControlAdapter businessControl() { return businessControl; }
    public FinancialManagementAdapter financialManagement() { return financialManagement; }
    public AccountingAdapter accounting() { return accounting; }
    public DatabaseIntegrationSubsystemFacade databaseIntegrationSubsystem() { return databaseIntegrationSubsystemFacade; }
    public UiSubsystemFacade uiSubsystem() { return uiSubsystemFacade; }
    public CrmSubsystemFacade crmSubsystem() { return crmSubsystemFacade; }
    public MarketingSubsystemFacade marketingSubsystem() { return marketingSubsystemFacade; }
    public SalesManagementSubsystemFacade salesManagementSubsystem() { return salesManagementSubsystemFacade; }
    public OrderProcessingSubsystemFacade orderProcessingSubsystem() { return orderProcessingSubsystemFacade; }
    public SupplyChainSubsystemFacade supplyChainSubsystem() { return supplyChainSubsystemFacade; }
    public ManufacturingSubsystemFacade manufacturingSubsystem() { return manufacturingSubsystemFacade; }
    public HrSubsystemFacade hrSubsystem() { return hrSubsystemFacade; }
    public ProjectManagementSubsystemFacade projectManagementSubsystem() { return projectManagementSubsystemFacade; }
    public ReportingSubsystemFacade reportingSubsystem() { return reportingSubsystemFacade; }
    public DataAnalyticsSubsystemFacade dataAnalyticsSubsystem() { return dataAnalyticsSubsystemFacade; }
    public BusinessIntelligenceSubsystemFacade businessIntelligenceSubsystem() { return businessIntelligenceSubsystemFacade; }
    public AutomationSubsystemFacade automationSubsystem() { return automationSubsystemFacade; }
    public BusinessControlSubsystemFacade businessControlSubsystem() { return businessControlSubsystemFacade; }
    public FinancialManagementSubsystemFacade financialManagementSubsystem() { return financialManagementSubsystemFacade; }
    public AccountingSubsystemFacade accountingSubsystem() { return accountingSubsystemFacade; }

    @Override
    public void close() {
        DatabaseConnectionManager.getInstance().shutdown();
    }
}
