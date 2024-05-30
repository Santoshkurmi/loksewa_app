import json

# Your data in the non-standard format
data = "[{name=Hello word,age=30},{name=HelloBye,age=15}]"

# Clean up the data by replacing '=' with ':'
data = data.replace('=', ':')

# Convert the data to a list of dictionaries
converted_data = []
for entry in data.split('},{'):
    entry = entry.strip('{}')
    pairs = entry.split(',')
    entry_dict = {}
    for pair in pairs:
        key, value = pair.split(':')
        entry_dict[key.strip()] = value.strip()
    converted_data.append(entry_dict)

# Convert the list of dictionaries to JSON
json_data = json.dumps(converted_data)

print(json_data)
