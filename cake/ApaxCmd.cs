// Build
// Copyright (c) 2023 Peter Kurhajec (PTKu), MTS,  and Contributors. All Rights Reserved.
// Contributors: https://github.com/ix-ax/ix/graphs/contributors
// See the LICENSE file in the repository root for more information.
// https://github.com/ix-ax/ix/blob/master/LICENSE
// Third party licenses: https://github.com/ix-ax/ix/blob/master/notices.md

using System.IO;
using Cake.Core.IO;
using Ix.Compiler;
using Microsoft.Win32;
using Octokit;
using Path = System.IO.Path;

public static class ApaxCmd
{
    public static void ApaxInstall(this BuildContext context, (string folder, string name) lib)
    {
        context.ProcessRunner.Start(Helpers.GetApaxCommand(), new ProcessSettings()
        {
            Arguments = "install -L",
            WorkingDirectory = context.GetAxFolder(lib),
            RedirectStandardOutput = false,
            RedirectStandardError = false,
            Silent = false
        }).WaitForExit();
    }

    public static void ApaxClean(this BuildContext context, (string folder, string name) lib)
    {
        context.ProcessRunner.Start(Helpers.GetApaxCommand(), new ProcessSettings()
        {
            Arguments = "clean",
            WorkingDirectory = context.GetAxFolder(lib),
            RedirectStandardOutput = false,
            RedirectStandardError = false,
            Silent = false
        }).WaitForExit();
    }

    public static void ApaxBuild(this BuildContext context, (string folder, string name) lib)
    {
        context.ProcessRunner.Start(Helpers.GetApaxCommand(), new ProcessSettings()
        {
            Arguments = "build",
            WorkingDirectory = context.GetAxFolder(lib),
            RedirectStandardOutput = false,
            RedirectStandardError = false,
            Silent = false
        }).WaitForExit();
    }

    public static void ApaxPack(this BuildContext context, (string folder, string name) lib)
    {
        context.ProcessRunner.Start(Helpers.GetApaxCommand(), new ProcessSettings()
        {
            Arguments = "pack",
            WorkingDirectory = context.GetAxFolder(lib),
            RedirectStandardOutput = false,
            RedirectStandardError = false,
            Silent = false
        }).WaitForExit();
    }

    public static void ApaxTest(this BuildContext context, (string folder, string name) lib)
    {
        var process = context.ProcessRunner.Start(Helpers.GetApaxCommand(), new ProcessSettings()
        {
            Arguments = "test",
            WorkingDirectory = context.GetAxFolder(lib),
            RedirectStandardOutput = false,
            RedirectStandardError = false,
            Silent = false
        });

        process.WaitForExit();

        if(process.GetExitCode() != 0)
            throw new TestFailedException();
    }

    public static void ApaxIxc(this BuildContext context, (string folder, string name) lib)
    {
        context.ProcessRunner.Start(Helpers.GetApaxCommand(), new ProcessSettings()
        {
            Arguments = "ixc",
            WorkingDirectory = context.GetAxFolder(lib),
            RedirectStandardOutput = false,
            RedirectStandardError = false,
            Silent = false
        }).WaitForExit();
    }

    public static void ApaxCopyArtifacts(this BuildContext context,  (string folder, string name) lib)
    {
        var libraryFolder = Path.Combine(Path.Combine(context.RootDir, lib.folder), "ctrl");
        var packageFile = $"{context.ApaxRegistry}-{lib.name}-{GitVersionInformation.SemVer}.apax.tgz";
        var sourceFile = Path.Combine(libraryFolder, packageFile);
            
        File.Copy(sourceFile, Path.Combine(context.ArtifactsApax, packageFile));
    }

    public static void ApaxPublish(this BuildContext context)
    {
        context.ProcessRunner.Start(Helpers.GetApaxCommand(), new ProcessSettings()
        {
            Arguments = $"login --registry https://npm.pkg.github.com--username { context.GitHubUser } --password { context.GitHubToken }",
            WorkingDirectory = context.ArtifactsApax,
            RedirectStandardOutput = false,
            RedirectStandardError = false,
            Silent = false
        }).WaitForExit();
        
        foreach (var apaxPackageFile in Directory.EnumerateFiles(context.ArtifactsApax))
        {
            var process = context.ProcessRunner.Start(Helpers.GetApaxCommand(), new ProcessSettings()
            {
                Arguments = $"publish -p {apaxPackageFile} -r  https://npm.pkg.github.com",
                WorkingDirectory = context.ArtifactsApax,
                RedirectStandardOutput = false,
                RedirectStandardError = false,
                Silent = false
            });

            process.WaitForExit();
            
            if (process.GetExitCode() != 0)
            {
                throw new PublishFailedException();
            }
        }
    }
}