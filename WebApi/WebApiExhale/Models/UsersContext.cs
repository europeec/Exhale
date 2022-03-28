using Microsoft.EntityFrameworkCore;

namespace WebApiExhale.Models
{
    public class UsersContext : DbContext
    {
        public DbSet<User> Users { get; set; }
        public UsersContext(DbContextOptions options) : base(options)
        {

        }
    }
}
