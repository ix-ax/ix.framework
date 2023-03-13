using integration.blazor.Data;
using intergrations;
using ix.framework.core.blazor.Toaster;
using Ix.Presentation.Blazor.Services;
using Microsoft.AspNetCore.Components;
using Microsoft.AspNetCore.Components.Web;
using ix.framework.core.DependencyInjection;
using static System.Formats.Asn1.AsnWriter;

namespace integration.blazor
{
    public class Program
    {
        public static void Main(string[] args)
        {
            var builder = WebApplication.CreateBuilder(args);

            // Add services to the container.
            builder.Services.AddRazorPages();
            builder.Services.AddServerSideBlazor();
            builder.Services.AddSingleton<WeatherForecastService>();
            
            builder.Services.AddIxBlazorServices();

            builder.Services.RegisterIxDataServices();
            builder.Services.AddSingleton<ToastService>();

            Entry.Plc.Connector.BuildAndStart();
            
            Entry.Plc.Connector.SubscriptionMode = Ix.Connector.ReadSubscriptionMode.Polling;

            Entry.Plc.process_data_manager.InitializeRepository(
                Ix.Repository.Json.Repository.Factory(new Ix.Framework.Data.Json.JsonRepositorySettings<Pocos.ixDataExamples.IxProductionData>(@"C:\TcOpen\Data\ProcessData")));

            Entry.Plc.MainContext.process_data_manager_remote_exec.InitializeRemoteDataExchange(
                Ix.Repository.Json.Repository.Factory(new Ix.Framework.Data.Json.JsonRepositorySettings<Pocos.ixDataExamples.IxProductionData>(@"C:\TcOpen\Data\ProcessData")));

            var app = builder.Build();

            // Configure the HTTP request pipeline.
            if (!app.Environment.IsDevelopment())
            {
                app.UseExceptionHandler("/Error");
                // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
                app.UseHsts();
            }

            app.UseHttpsRedirection();

            app.UseStaticFiles();

            app.UseRouting();

            app.MapBlazorHub();
            app.MapFallbackToPage("/_Host");

            #region InitializeRemoteTask
            Entry.Plc.ixcore_remote_tasks._remoteTask.Initialize(() => Console.WriteLine($"Remote task executed PLC sent this string: '{Entry.Plc.ixcore_remote_tasks._remoteTask.Message.GetAsync().Result}'"));
            #endregion

            app.Run();



        }
    }
}