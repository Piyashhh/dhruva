#!/data/data/com.termux/files/usr/bin/bash
# Dhruva local brain. Usage: bash termux.sh [smart|fast]   (smart = 3B, fast = 1.5B)
set -e
pkg update -y && pkg install -y llama-cpp curl
mkdir -p ~/models && cd ~/models
if [ "$1" = fast ]; then R=Qwen/Qwen2.5-1.5B-Instruct-GGUF; F=qwen2.5-1.5b-instruct-q4_k_m.gguf
else R=Qwen/Qwen2.5-3B-Instruct-GGUF; F=qwen2.5-3b-instruct-q4_k_m.gguf; fi
[ -f "$F" ] || curl -L -C - -o "$F" "https://huggingface.co/$R/resolve/main/$F"
cat > "$PREFIX/bin/dhruva" <<EOT
#!/data/data/com.termux/files/usr/bin/bash
termux-wake-lock 2>/dev/null
exec llama-server -m ~/models/$F --host 127.0.0.1 --port 8080 -c 4096 -t 4
EOT
chmod +x "$PREFIX/bin/dhruva"
echo "Done. Start the brain any time with:  dhruva"
