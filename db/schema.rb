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

ActiveRecord::Schema.define(version: 2022_03_13_100544) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cells", force: :cascade do |t|
    t.integer "row"
    t.integer "column"
    t.integer "height"
    t.integer "level"
    t.integer "north"
    t.integer "south"
    t.integer "east"
    t.integer "west"
    t.bigint "maze_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "links", default: [], null: false, array: true
    t.integer "distance"
    t.index ["maze_id"], name: "index_cells_on_maze_id"
  end

  create_table "mazes", force: :cascade do |t|
    t.string "title"
    t.integer "algo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "file_name"
    t.integer "row_count"
    t.integer "column_count"
    t.string "background"
    t.integer "color"
    t.integer "palette"
  end

  add_foreign_key "cells", "mazes"
end
