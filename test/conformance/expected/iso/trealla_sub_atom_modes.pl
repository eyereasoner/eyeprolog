sub_atom_all(0, 0, 3, '').
sub_atom_all(0, 1, 2, a).
sub_atom_all(0, 2, 1, ab).
sub_atom_all(0, 3, 0, abc).
sub_atom_all(1, 0, 2, '').
sub_atom_all(1, 1, 1, b).
sub_atom_all(1, 2, 0, bc).
sub_atom_all(2, 0, 1, '').
sub_atom_all(2, 1, 0, c).
sub_atom_all(3, 0, 0, '').
sub_atom_length_2(0, 1, ab).
sub_atom_length_2(1, 0, bc).
sub_atom_before_0_length_2(1, ab).
sub_atom_before_0(0, 3, '').
sub_atom_before_0(1, 2, a).
sub_atom_before_0(2, 1, ab).
sub_atom_before_0(3, 0, abc).
sub_atom_after_0(0, 3, abc).
sub_atom_after_0(1, 2, bc).
sub_atom_after_0(2, 1, c).
sub_atom_after_0(3, 0, '').
sub_atom_length_2_after_0(1, bc).
