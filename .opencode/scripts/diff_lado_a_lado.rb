#!/usr/bin/env ruby
# Gera .opencode/mudancas.html com o diff não commitado em duas colunas.
# Sobrescreve o arquivo a cada execução.

require 'cgi'

OUT_PATH = '.opencode/mudancas.html'

def status_entries
  `git status --porcelain`.strip.lines.map { |line| [line[0, 2].strip, line[3..].strip] }
    .reject { |_, path| path.end_with?('/') }
    .reject { |_, path| path.start_with?('coverage/', '.opencode/') }
end

def parse_diff(text)
  files = []
  current = nil
  hunk = nil
  text.each_line do |line|
    line = line.chomp
    case line
    when /^diff --git/
      current = { hunks: [] }
      files << current
    when /^@@ -(\d+)(?:,\d+)? \+(\d+)(?:,\d+)? @@/
      hunk = { old_start: Regexp.last_match(1).to_i, new_start: Regexp.last_match(2).to_i, lines: [] }
      current[:hunks] << hunk
    else
      next if line.start_with?('index ', 'new file', 'deleted file', 'similarity', 'rename ', 'old mode', 'new mode', 'Binary files', '\\ No newline')
      hunk[:lines] << line[1..] if hunk && [' ', '-', '+'].include?(line[0])
    end
  end
  files
end

def hunk_rows(hunk)
  rows = []
  pending = { del: [], add: [] }
  old_no = hunk[:old_start]
  new_no = hunk[:new_start]

  hunk[:lines].each do |line|
    case line[0]
    when ' '
      flush_pending(pending, rows)
      rows << { old: line[1..], old_no: old_no, new: line[1..], new_no: new_no, kind: :ctx }
      old_no += 1
      new_no += 1
    when '-'
      pending[:del] << [line[1..], old_no]
      old_no += 1
    when '+'
      pending[:add] << [line[1..], new_no]
      new_no += 1
    end
  end
  flush_pending(pending, rows)
  rows
end

def flush_pending(pending, rows)
  until pending[:del].empty? && pending[:add].empty?
    removed = pending[:del].shift
    added = pending[:add].shift
    rows << { old: removed&.first, old_no: removed&.last, new: added&.first, new_no: added&.last, kind: :mod }
  end
end

def render
  parts = []
  status_entries.each do |status, path|
    if status == '??'
      old_lines = []
      new_lines = File.readlines(path).map(&:chomp)
      hunks = [{ old_start: 0, new_start: 1, lines: new_lines.map { |l| "+#{l}" } }]
      file = { hunks: hunks }
    else
      file = parse_diff(`git diff -- "#{path}"`).first
      next if file.nil? || file[:hunks].empty?
    end

    parts << "<div class=\"file\"><div class=\"file-header\">#{CGI.escapeHTML(path)}</div><table>"
    file[:hunks].each do |hunk|
      parts << "<tr class=\"hunk-row\"><td colspan=\"4\">#{CGI.escapeHTML("@@ -#{hunk[:old_start]} +#{hunk[:new_start]} @@")}</td></tr>"
      hunk_rows(hunk).each do |row|
        parts << "<tr><td class=\"num\">#{row[:old_no]}</td><td class=\"#{row[:kind] == :ctx ? 'ctx' : 'del'}\">#{CGI.escapeHTML(row[:old].to_s)}</td><td class=\"num\">#{row[:new_no]}</td><td class=\"#{row[:kind] == :ctx ? 'ctx' : 'add'}\">#{CGI.escapeHTML(row[:new].to_s)}</td></tr>"
      end
    end
    parts << '</table></div>'
  end
  parts
end

def html
  <<~HTML
    <!DOCTYPE html>
    <html lang="pt-BR">
    <head>
      <meta charset="utf-8">
      <title>Mudanças — ficha_rpg</title>
      <style>
        body { background: #000; color: #c9d1d9; font-family: ui-monospace, "JetBrains Mono", Menlo, Consolas, monospace; font-size: 13px; margin: 24px; }
        .file { border: 1px solid #30363d; border-radius: 6px; margin-bottom: 24px; overflow: hidden; }
        .file-header { background: #161b22; color: #58a6ff; padding: 8px 12px; font-weight: bold; }
        table { width: 100%; border-collapse: collapse; table-layout: fixed; }
        td { padding: 1px 8px; vertical-align: top; white-space: pre-wrap; word-break: break-all; }
        td.num { width: 44px; text-align: right; color: #6e7681; user-select: none; border-right: 1px solid #21262d; }
        .ctx { background: #0d1117; }
        .del { background: rgba(248, 81, 73, 0.15); color: #ff7b72; }
        .add { background: rgba(63, 185, 80, 0.15); color: #7ee787; }
        .hunk-row td { background: #161b22; color: #8b949e; padding: 4px 12px; }
        .legend { margin-bottom: 16px; color: #8b949e; }
        .legend span { padding: 2px 8px; border-radius: 4px; margin-right: 8px; }
        .legend .del { color: #ff7b72; } .legend .add { color: #7ee787; }
      </style>
    </head>
    <body>
      <h1>Mudanças não commitadas</h1>
      <div class="legend"><span class="del">removido</span><span class="add">adicionado</span></div>
      #{render.join("\n")}
    </body>
    </html>
  HTML
end

File.write(OUT_PATH, html)
puts "Gerado: #{File.expand_path(OUT_PATH)}"
