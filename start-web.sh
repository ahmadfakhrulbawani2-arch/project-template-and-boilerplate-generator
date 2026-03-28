#!/bin/bash

BASE_DIR=$(pwd)
LOG="$BASE_DIR/history.log"

if ! [ -f "$LOG" ]; then 
  touch "$LOG"
  echo "===========================  Created Log on $(date)  ===========================" >> "$LOG"
  printf "\n" >> "$LOG"
fi

log () {
  local STATUS=$1
  local INFO=$2
  echo "[$STATUS] [$(date '+%Y-%m-%d %H:%M')] $INFO" >> "$LOG"
}

while true; do 
  read -p "Web Project Name (lowercase & kebab-case recommended): " WEB_DIR_NAME

  # set default name if no user input
  WEB_DIR_NAME=${WEB_DIR_NAME:-"my-website"}

  if [ -d "$WEB_DIR_NAME" ]; then
    echo "The $WEB_DIR_NAME already exist! Please enter another name"
    echo "==========================================================="
    log "ERROR" "The $WEB_DIR_NAME already exist!"
  else 
    break
  fi
done

# then create project dir
mkdir "$WEB_DIR_NAME"

# enter the dir and create html, css, js
cd "$WEB_DIR_NAME/"

# ask user how many pages they want to create
while true; do 
  read -p "How many pages you want to create? (default is 1, homepage excluded): " PAGES_CNT
  PAGES_CNT=$(echo "$PAGES_CNT" | xargs) # trim whitespace
  PAGES_CNT=${PAGES_CNT:-"1"} # default val 1
  if ! [[ "$PAGES_CNT" =~ ^[0-9]+$ ]] || [ "$PAGES_CNT" -eq 0 ]; then
    log "ERROR" "Pages count must be a number!"
    echo "Input must be a number!"
    echo "==========================================================="
  else 
    break
  fi
done

cat <<EOF > "index.html"
<!-- This file is auto generated for ${WEB_DIR_NAME} -->

<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link rel="stylesheet" href="style.css" />
    <title>${WEB_DIR_NAME^^}</title>
  </head>
  <body>
    <header>
      <h1>Welcome to ${WEB_DIR_NAME}</h1>
    </header>
    <main>
      <h1>Hello World</h1>
    </main>
    <footer id="footer"></footer>
    <script src="../globals.js"></script>
    <script src="script.js"></script>
  </body>
</html>
EOF

cat <<EOF > "style.css"
/* This file is auto generated for ${WEB_DIR_NAME}  */

/* Theme & variables */
:root {
  --bg-color: oklch(1 0 0);
  --text: oklch(0.15 0 0);
  --primary: oklch(0.55 0.18 260);
  --primary-hover: oklch(0.5 0.18 260);
  --secondary: oklch(0.95 0.01 260);
  --border: oklch(0.9 0.01 260);
  --card: oklch(1 0 0);
  --muted: oklch(0.55 0.02 260);
  --radius: 0.5rem;
}

/* Dark theme. Enable by adding class="dark" in <html></html> */
.dark {
  --bg-color: oklch(0.12 0 0);
  --text: oklch(0.95 0 0);
  --primary: oklch(0.7 0.16 260);
  --primary-hover: oklch(0.65 0.16 260);
  --secondary: oklch(0.2 0.02 260);
  --border: oklch(0.3 0.02 260);
  --card: oklch(0.18 0.02 260);
  --muted: oklch(0.7 0.02 260);
}

/* Default reset */
*,
*::after,
*::before {
  box-sizing: border-box;
}

* {
  padding: 0;
  margin: 0;
}
EOF

cat <<EOF > "script.js"
// This file is auto generated for ${WEB_DIR_NAME}

// Get started with DOM
EOF


for((i=1; i<=PAGES_CNT; i++)); do
  mkdir "pages-$i/"
  cat <<EOF > "pages-$i/index.html"
<!-- This file is auto generated for ${WEB_DIR_NAME} -->

<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link rel="stylesheet" href="style.css" />
    <title>${WEB_DIR_NAME^^} | PAGES-${i}</title>
  </head>
  <body>
    <header>
      <h1>Welcome to ${WEB_DIR_NAME}</h1>
    </header>
    <main>
      <h1>Hello World</h1>
    </main>
    <footer></footer>
    <script src="script.js"></script>
  </body>
</html>
EOF

  cat <<EOF > "pages-$i/style.css"
/* This file is auto generated for ${WEB_DIR_NAME}  */

/* Theme & variables */
:root {
  --bg-color: oklch(1 0 0);
  --text: oklch(0.15 0 0);
  --primary: oklch(0.55 0.18 260);
  --primary-hover: oklch(0.5 0.18 260);
  --secondary: oklch(0.95 0.01 260);
  --border: oklch(0.9 0.01 260);
  --card: oklch(1 0 0);
  --muted: oklch(0.55 0.02 260);
  --radius: 0.5rem;
}

/* Dark theme. Enable by adding class="dark" in <html></html> */
.dark {
  --bg-color: oklch(0.12 0 0);
  --text: oklch(0.95 0 0);
  --primary: oklch(0.7 0.16 260);
  --primary-hover: oklch(0.65 0.16 260);
  --secondary: oklch(0.2 0.02 260);
  --border: oklch(0.3 0.02 260);
  --card: oklch(0.18 0.02 260);
  --muted: oklch(0.7 0.02 260);
}

/* Default reset */
*,
*::after,
*::before {
  box-sizing: border-box;
}

* {
  padding: 0;
  margin: 0;
}
EOF

  cat <<EOF > "pages-$i/script.js"
// This file is auto generated for ${WEB_DIR_NAME}

// Get started with DOM
EOF
done

# ask user want to add readme or not
read -p "Do you want to add README to your project? (y/n): " W_WEB_README

if [[ "$W_WEB_README" =~ ^[Yy]$ ]]; then
  cat <<EOF > README.md
# ${WEB_DIR_NAME^^}
_Fill in with website description & documentation_
EOF
  WEB_README_STATS="with README"
else 
  WEB_README_STATS="without README"
fi

# ask user want to initialize git or not
read -p "Do you want to initialize git for your project? (y/n): " W_WEB_GIT

if [[ "$W_WEB_GIT" =~ ^[Yy]$ ]]; then
  git init > /dev/null 2>&1
  git add .
  git commit -m "feat: initial commit of $WEB_DIR_NAME" > /dev/null 2>&1
  WEB_GIT_STATS="with git"
else 
  WEB_GIT_STATS="without git"
fi

# back to this shell dir
cd ..
# logging the info
log "SUCCESS" "Create $WEB_DIR_NAME $WEB_README_STATS and $WEB_GIT_STATS"
echo 
echo "Success create $WEB_DIR_NAME $WEB_README_STATS and $WEB_GIT_STATS!"

# ask user want to open vscode or not
echo
read -p "Do you want to open VSCode? (y/n): " WEB_OPEN

if [[ "$WEB_OPEN" =~ ^[Yy]$ ]]; then 
  if command -v code >/dev/null 2>&1; then
    code "$WEB_DIR_NAME"
  else 
    echo "Cannot open VSCode (not detected in path)"
  fi
fi