import re

config = [line.strip() for line in open("coc.vim", "r").readlines()]

def string_to_reject(string):
    result = False
    if string in ["\""]:
        result = True

    return result

def string_to_accept(string):
    result = False
    accepted_keywords = ["nnoremap", "nmap", "noremap", "\""]
    
    result = any(subs in string for subs in accepted_keywords)

    return result

def header(string):
    string = re.sub(r"^\" \[docs\]", "###", string)

    return f"\n{string}\n"

doc_block_started = False
doc_lines = []

for line in config:
    if "[docs]" in line:
        doc_block_started = True
        doc_lines.append(header(line))
        continue
    elif line == "":
        doc_block_started = False
        continue

    if doc_block_started and string_to_accept(line) and not string_to_reject(line):
        if not line.startswith("\"") and not line.startswith("#"):
            line = f"    {line}"
        else:
            line = re.sub(r"^\"\s*", "", line)
            line = f"{line}\n"
        doc_lines.append(line)

print("\n".join(doc_lines))
