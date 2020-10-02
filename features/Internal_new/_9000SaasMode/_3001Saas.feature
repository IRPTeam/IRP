#language: en
@tree
@Positive
@Other

Feature: Saas data separation

As a Developer
I want to create a system for separating data by area
For multiple companies to work in a single base

Background:
    Given I launch TestClient opening script or connect the existing one

Scenario: _9001001 check the Saas mode constant on and off
    And I set "True" value to the constant "SaasMode"
    And I set "False" value to the constant "SaasMode"
    And I close all client application windows


