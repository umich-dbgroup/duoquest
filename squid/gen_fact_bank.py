import json
import random

INPUT = 'factbank.json'
OUTPUT = 'factbank.html'

html_output = "<html><head><title>Factbank</title></head><body>"
factbank = json.load(open(INPUT))
for task, facts in factbank.items():
    random.shuffle(facts)
    html_output += f"<h1>Task {task}</h1><ol>"
    for fact in facts:
        html_output += f"<li>{fact}</li>"
    html_output += "</ol>"

html_output += "</body></html>"

with open(OUTPUT, 'w') as f:
    f.write(html_output)
