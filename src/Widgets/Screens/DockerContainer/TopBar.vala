/*
   This file is part of Pilot Whale, a fork of Whaler by sdv43.

   Whaler is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License
   as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
   Whaler is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty
   of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

   You should have received a copy of the GNU General Public License along with Whaler. If not, see <https://www.gnu.org/licenses/>.

   This fork, Pilot Whale, was created and modified by jumpyvi in 2025.
 */

using Utilities;

namespace Widgets.Screens.Container {
    class TopBar : Gtk.Box {
        private DockerContainer container;

        public TopBar () {
            var state_docker_container = State.Root.get_instance ().screen_docker_container;

            this.orientation = Gtk.Orientation.HORIZONTAL;
            this.spacing = 0;
            this.margin_start = 20;


            state_docker_container.notify["service"].connect (() => {
                if(this.get_first_child () != null){
                    this.remove (this.get_first_child ());
                    this.remove(this.get_first_child ());
                }
                this.container = state_docker_container.service;
                assert_nonnull (this.container);

                this.prepend (this.build_container_block ());
                this.append (this.build_container_actions ());
            });
        }

        private Gtk.Widget build_container_block () {
            var box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);

            box.prepend (this.build_container_name ());
            box.append (this.build_container_status_label () ?? this.build_container_image ());

            return box;
        }

        private Gtk.Widget build_container_name () {
            var container_name = new Gtk.Label (this.container.name);
            container_name.halign = Gtk.Align.START;

            return container_name;
        }

        private Gtk.Widget? build_container_status_label () {
            var label = Widgets.Utils.DockerContainerStatusLabel.create_by_container (this.container);

            if (label == null) {
                return null;
            }

            label.halign = Gtk.Align.START;

            return label;
        }

        private Gtk.Widget build_container_image () {
            var label = new Gtk.Label (this.container.image);
            label.halign = Gtk.Align.START;

            return label;
        }

        private Gtk.Widget build_container_actions () {
            var actions = new TopBarActions (this.container);
            actions.valign = Gtk.Align.CENTER;

            return actions;
        }
    }
}
