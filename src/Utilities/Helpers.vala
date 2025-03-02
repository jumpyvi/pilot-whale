/*
   This file is part of Bubbler, a fork of Whaler by sdv43.

   Whaler is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License
   as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
   Whaler is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty
   of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

   You should have received a copy of the GNU General Public License along with Whaler. If not, see <https://www.gnu.org/licenses/>.

   This fork, Bubbler, was created and modified by jumpyvi in 2025.
 */

namespace Utilities {
    string ucfirst (string str) {
        return str.up (1) + str.substring (1);
    }

    string clean_image_name(string name){
        string clean_search_text = "";

        foreach (char c in name.to_utf8()) {
                if ((c >= '0' && c <= '9') || 
                    (c >= 'A' && c <= 'Z') || 
                    (c >= 'a' && c <= 'z') || 
                    c == '_' || c == '-' || c == '/' || c == '.' || c == ':') {
                    clean_search_text += c.to_string();
                }
            }

        return clean_search_text;
    }
}
