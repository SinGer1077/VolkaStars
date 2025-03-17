let project = new Project('New Project');
project.addAssets('Assets/**');
project.addShaders('Shaders/**');
project.addSources('Sources');
project.addLibrary('zui');
project.addAssets("Libraries/zui/examples/SharedAssets");
resolve(project);
