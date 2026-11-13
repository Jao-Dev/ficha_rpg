#!/usr/bin/env ruby
# Gera .opencode/mudancas.md com as mudanças em blocos ```diff (estilo git).
# Sobrescreve o arquivo a cada execução.
# Com working tree sujo, mostra as mudanças não commitadas; caso contrário,
# mostra o diff do último commit.

OUT_PATH = '.opencode/mudancas.md'
SKIP_PREFIXES = [ 'coverage/', '.opencode/' ].freeze

def status_entries
  `git status --porcelain`.lines.map(&:chomp).reject(&:empty?)
    .map { |line| [line[0, 2].strip, line[3..]] }
    .reject { |_, path| path.end_with?('/') }
    .reject { |_, path| SKIP_PREFIXES.any? { |prefix| path.start_with?(prefix) } }
end

def last_commit_files
  `git diff-tree --no-commit-id --name-status -r HEAD`.strip.lines
    .map { |line| line.chomp.split("\t") }
    .select { |parts| parts.size == 2 }
    .map { |status, path| [status, path] }
    .reject { |status, path| status == 'D' || SKIP_PREFIXES.any? { |prefix| path.start_with?(prefix) } }
end

def diff_body(status, path, base = nil)
  if status == '??'
    File.readlines(path).map { |line| "+#{line.chomp}" }.join("\n")
  else
    source = base ? "#{base} -- \"#{path}\"" : "HEAD -- \"#{path}\""
    `git diff #{source}`.each_line
      .reject { |line| line.start_with?('diff --git', 'index ', '--- ', '+++ ', 'new file', 'deleted file', 'similarity', 'rename ', 'old mode', 'new mode', 'Binary files', '\\ No newline') }
      .map(&:chomp).join("\n")
  end
end

entries = status_entries
parts = [ '# Mudanças não commitadas', '' ]

if entries.empty?
  parts[0] = '# Mudanças do último commit'
  entries = last_commit_files
  parts << 'Nenhuma mudança para exibir.' if entries.empty?
end

unless entries.empty?
  base = entries.equal?(last_commit_files) ? 'HEAD~1' : nil
  entries.each do |status, path|
    body = diff_body(status, path, base)
    parts << "## #{path}" << '' << "```diff" << body << "```" << ''
  end
end

File.write(OUT_PATH, parts.join("\n"))
puts "Gerado: #{File.expand_path(OUT_PATH)}"
