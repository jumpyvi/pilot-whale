/*
 * This file is part of Whaler.
 * Whaler is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 * Whaler is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty
 * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 * You should have received a copy of the GNU General Public License along with Whaler. If not, see <https://www.gnu.org/licenses/>.
 */

public class Widgets.Utils.ContainerPullSearchBar : Adw.Bin{
    construct{
        var state = State.Root.get_instance ();
        Gtk.SearchEntry search = new Gtk.SearchEntry ();

        search.width_request = 240;
        search.placeholder_text = _("Search images...");
        search.search_delay = 1000;
        search.search_changed.connect (() => {
            state.screen_main.search_term = search.text.down (search.text.length);
        });
        this.child = search;
        this.margin_start = 20;
        this.margin_end = 20;
    }

    public ContainerPullSearchBar (){
        Object();
    }
}