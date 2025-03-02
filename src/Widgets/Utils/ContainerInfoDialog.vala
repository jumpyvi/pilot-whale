/*
   This file is part of Bubbler, a fork of Whaler by sdv43.

   Whaler is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License
   as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
   Whaler is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty
   of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

   You should have received a copy of the GNU General Public License along with Whaler. If not, see <https://www.gnu.org/licenses/>.

   This fork, Bubbler, was created and modified by jumpyvi in 2025.
 */

using Utilities;
using Docker;

class Widgets.Utils.ContainerInfoDialog : Adw.Dialog {
    Gee.HashMap<DockerContainer, ContainerInspectInfo?> containers_info;
    protected Adw.HeaderBar headerbar { get; set; }

    public ContainerInfoDialog (Gee.HashMap<DockerContainer, ContainerInspectInfo?> containers_info) {
        this.set_content_width (460);
        this.set_content_height (400);
        this.containers_info = containers_info;

        var toolbarview = new Adw.ToolbarView () {
			content = build_content_area ()
		};
		headerbar = new Adw.HeaderBar ();
		toolbarview.add_top_bar (headerbar);
		this.child = toolbarview;
    }

    private Gtk.Widget build_content_area () {
        var box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);

        var stack = new Gtk.Stack ();
        foreach (var entry in this.containers_info) {
            var container = entry.key;
            var info = entry.value;

            stack.add_titled (this.build_tab (info), container.id, container.name);
        }
        box.append (stack);

        if (this.containers_info.size > 1) {
            var switcher = new Gtk.StackSwitcher ();
            switcher.stack = stack;
            switcher.halign = Gtk.Align.CENTER;
            box.prepend (switcher);
        }

        return box;
    }

    private Gtk.Widget build_tab (ContainerInspectInfo info) {
        var scrolled_window = new Gtk.ScrolledWindow ();
        var box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);

        box.append (this.build_row (_ ("Name"), {info.name}));
        box.append (this.build_row (_ ("Image"), {info.image}));
        box.append (this.build_row (_ ("Status"), {info.status}));

        if (info.ports != null) {
            box.append (this.build_row (_ ("Ports"), info.ports));
        }

        if (info.binds != null) {
            box.append (this.build_row (_ ("Binds"), info.binds));
        }

        if (info.envs != null) {
            box.append (this.build_row (_ ("Env"), info.envs));
        }

        scrolled_window.set_child (box);
        scrolled_window.margin_start = 10;
        scrolled_window.margin_top = 10;

        return scrolled_window;
    }

    private Gtk.Widget build_row (string label, string[] values) {
        var box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);

        box.append (this.build_label (label));
        box.append (this.build_values (values));

        return box;
    }

    private Gtk.Widget build_label (string text) {
        var box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
        box.width_request = 140;

        var label = new Gtk.Label (text);
        label.halign = Gtk.Align.END;
        label.valign = Gtk.Align.START;

        box.append (label);

        return box;
    }

    private Gtk.Widget build_values (string[] values) {
        if (values.length == 1) {
            return this.build_value (values[0]);
        }

        var box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);

        foreach (var value in values) {
            box.append (this.build_value (value));
        }

        return box;
    }

    private Gtk.Widget build_value (string value) {
        var label = new Gtk.Label (value);

        label.halign = Gtk.Align.START;
        label.selectable = true;
        label.single_line_mode = false;
        label.wrap = true;
        label.wrap_mode = Pango.WrapMode.CHAR;

        return label;
    }
}
