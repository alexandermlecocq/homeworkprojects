# Loop through files
import csv
import os

num_votes = 0
candidates = []
vote_counts = []
file = os.path.join('poll_data.csv')
# Open current CSV
with open(file) as csvFile:

    csvReader = csv.reader(csvFile, delimiter=',')

    # Skip headers
    next(csvReader,None)

    # Process the votes
    for row in csvReader:
        # Add to total number of votes
        num_votes = num_votes + 1

        # The candidate voted for
        candidate = row[2]

        # If the candidate has other votes then add to vote total
        if candidate in candidates:
            candidate_index = candidates.index(candidate)
            vote_counts[candidate_index] = vote_counts[candidate_index] + 1
        # Else create new spot in list for candidate
        else:
            candidates.append(candidate)
            vote_counts.append(1)


# Create variables for calculations
percentages = []
max_votes = vote_counts[0]
max_index = 0

# Percentage of vote for each candidate and the winner
for count in range(len(candidates)):
    vote_percentage = vote_counts[count]/num_votes*100
    percentages.append(vote_percentage)
    if vote_counts[count] > max_votes:
        max_votes = vote_counts[count]
        print(max_votes)
        max_index = count
winner = candidates[max_index]

# Round decimal
print(num_votes)
print(winner)

percentages = [round(i,2) for i in percentages]

for n in range(len(candidates)):
    print(f"{candidates[n]} : {vote_counts[n]} / {percentages[n]}")