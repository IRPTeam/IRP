
Procedure SetVisible(Object, Form) Export
	IsStandard = Object.Kind = PredefinedValue("Enum.AgreementKinds.Standard");
	IsRegular = Object.Kind = PredefinedValue("Enum.AgreementKinds.Regular");
	ApArByStandardAgreements = Object.ApArPostingDetail = PredefinedValue("Enum.ApArPostingDetail.ByStandardAgreement");
	IsCustomer = Object.Type = PredefinedValue("Enum.AgreementTypes.Customer");
	
	Form.Items.ItemSegment.Visible = IsCustomer;	
	
	Form.Items.StandardAgreement.Visible = ApArByStandardAgreements;
	
	Form.Items.ApArPostingDetail.ReadOnly       = IsStandard;
	Form.Items.PriceType.Visible                = IsRegular;
	Form.Items.PriceIncludeTax.Visible          = IsRegular;
	Form.Items.NumberDaysBeforeShipment.Visible = IsRegular;
	Form.Items.Store.Visible                    = IsRegular;
	Form.Items.Type.Visible                     = IsRegular;
	Form.Items.CreditLimitAmount.Visible            = Object.UseCreditLimit;
	Form.Items.CurrencyMovementTypeCurrency.Visible = Object.UseCreditLimit;
EndProcedure