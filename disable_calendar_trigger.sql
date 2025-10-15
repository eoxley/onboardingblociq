-- Temporarily disable calendar event trigger that's causing issues
DROP TRIGGER IF EXISTS create_calendar_event_on_compliance_insert ON compliance_assets;
DROP TRIGGER IF EXISTS create_calendar_event_on_compliance_update ON compliance_assets;

