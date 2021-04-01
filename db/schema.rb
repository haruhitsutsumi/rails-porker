# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20_210_317_124_241) do
  create_table 'hands', force: :cascade do |t|
    t.boolean  'flashj'
    t.string   'pairj'
    t.boolean  'straightj'
    t.string   'finalj'
    t.datetime 'created_at',    null: false
    t.datetime 'updated_at',    null: false
    t.string   'array1'
    t.string   'array2'
    t.string   'array3'
    t.string   'array4'
    t.string   'array5'
    t.string   'cards'
    t.string   'error_message'
  end
end
