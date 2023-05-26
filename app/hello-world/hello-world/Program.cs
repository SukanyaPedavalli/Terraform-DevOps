namespace hello_world
{
    using System.Runtime.CompilerServices;

    public class Program
    {
        public static void Main(string[] args)
        {
            var builder = WebApplication.CreateBuilder(args);
            
            var app = builder.Build();

            app.MapGet("/", (HttpRequest request) =>
            {
                return TypedResults.Ok(request.Headers);
            });

            app.Run();
        }
    }
}