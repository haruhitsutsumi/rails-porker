module Const::Regex
  FORMATCHECK = /^[^ ]+\b {1}\b[^ ]+\b {1}\b[^ ]+\b {1}\b[^ ]+\b {1}\b[^ ]+\b$/.freeze
  LETTERCHECK = /\b[SCHD]([1-9]|1[0-3])\b/.freeze
  EXTRACTNUMBER = /([1-9]|1[0-3])\b/
  EXTRACTSUIT = /S|D|C|H/
end
