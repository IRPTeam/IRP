
#language: en
@ExportScenarios
@IgnoreOnCIMainBuild
@tree

Feature: export scenarios to check that a document is posted

# Manager and test client run in the same base, so the document can be found
# directly at the server by its number. The document type and number are passed
# as scenario-name parameters and substituted by Vanessa Automation into the body.
#
# Usage:
#   And document "SalesOrder" number "000000018" is posted
#   And document "PurchaseInvoice" number "$$NumberPI$$" is posted

Scenario: document "[DocumentType]" number "[Number]" is posted
	And I execute 1C:Enterprise script at server
		| 'Ref = Documents.[DocumentType].FindByNumber("[Number]"); If Not ValueIsFilled(Ref) Then Raise "Document [DocumentType] [Number] is not found" EndIf; If Not Ref.Posted Then Raise "Document [DocumentType] [Number] is not posted, but was expected to be posted" EndIf;' |
