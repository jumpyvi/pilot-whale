/*
   This file is part of Bubbler, a fork of Whaler by sdv43.

   Whaler is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License
   as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
   Whaler is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty
   of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

   You should have received a copy of the GNU General Public License along with Whaler. If not, see <https://www.gnu.org/licenses/>.

   This fork, Bubbler, was created and modified by jumpyvi in 2025.
 */

using Utilities.Sorting;
using Utilities.Constants;

class Widgets.Screens.Main.ContainersGridFilter : Gtk.Box {
    public ContainersGridFilter () {
        var state = State.Root.get_instance ();
        var search_entry = this.build_search_entry ();

        this.sensitive = false;
        this.orientation = Gtk.Orientation.HORIZONTAL;
        this.spacing = 10;
        this.add_css_class ("grid_search_bar");

        this.prepend (search_entry);
        this.append (this.build_sorting_dropdown ());

        state.notify["containers"].connect (() => {
            this.sensitive = state.containers.size > 0;
        });
    }


    private Gtk.Widget build_search_entry () {
        var state = State.Root.get_instance ();
        var entry = new Gtk.SearchEntry ();
        var settings = new Settings (APP_ID);

        entry.width_request = 240;
        entry.search_changed.connect (() => {
            state.screen_main.search_term = entry.text.down (entry.text.length);
        });
        entry.placeholder_text = _("Search container...");

        settings.bind ("main-screen-search-term", entry, "text", SettingsBindFlags.DEFAULT);

        return entry;
    }

    private Gtk.Widget build_sorting_dropdown () {
        SortingInterface[] sortings = {
            new SortingStatus (),
            new SortingName (),
            new SortingType ()
        };
        
        var state = State.Root.get_instance ();
        var box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
        var label = new Gtk.Label (_ ("Sort by:"));
        box.prepend (label);
        
        var string_list = new Gtk.StringList (null);
        foreach (var sorting in sortings) {
            string_list.append (sorting.name);
        }
        
        var dropdown = new Gtk.DropDown (string_list, null);
        box.append (dropdown); 
        

        dropdown.notify["selected"].connect (() => {
            state.screen_main.sorting = sortings[dropdown.selected];
        });
        
        var settings = new Settings (APP_ID);
        settings.bind ("main-screen-sorting", dropdown, "selected", SettingsBindFlags.DEFAULT);
        
        return box;
    }

}
