def increase_dates(file_path):
    with open(file_path, 'r') as file:
        data = file.readlines()
    modified_data = []
    for line in data:
        if line.strip().startswith('('):
            parts = line.strip().split(', ')
            for i, part in enumerate(parts):
                if len(part) == 12 and part[0] == "'": 
                    date = part.strip("'")
                    year, month, day = map(int, date.split('-'))
                    day += 2 
                    if day > 31:
                        day = 1
                        month += 1
                    modified_date = f"'{year:04d}-{month:02d}-{day:02d}'"
                    parts[i] = modified_date
            modified_line = ', '.join(parts)
            modified_data.append(modified_line + '\n')
        else:
            modified_data.append(line)
    with open('modified_data.txt', 'w') as modified_file:
        modified_file.writelines(modified_data)

file_path = 'data.txt'
increase_dates(file_path)