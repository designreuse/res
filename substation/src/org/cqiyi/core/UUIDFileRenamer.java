package org.cqiyi.core;

import java.io.File;

import cn.dreampie.common.util.stream.FileRenamer;

public class UUIDFileRenamer extends FileRenamer {

	@Override
	public File rename(File f) {

		String name = f.getName();
		String body = null;
		String ext = null;

		int dot = name.lastIndexOf(".");
		if (dot != -1) {
			body = name.substring(0, dot);
			ext = name.substring(dot); // includes "."
		} else {
			body = name;
			ext = "";
		}

		return new File(f.getParent(), Utils.getRandomUUID() + ext);
	}

}
