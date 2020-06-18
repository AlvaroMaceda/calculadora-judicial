json.municipality_code @municipality_code
json.notification @notification_date.strftime('%Y-%m-%d')
json.days @days
json.deadline @deadline.strftime('%Y-%m-%d')
json.holidays(@holidays_affected) do |holiday|
    json.date holiday.date
    json.kind holiday.holidayable.kind
    json.territory holiday.holidayable.name
end
json.missing_holidays(@missing_holidays) do |miss|
    json.kind miss.territory.kind
    json.territory miss.territory.name
    json.years miss.years
end